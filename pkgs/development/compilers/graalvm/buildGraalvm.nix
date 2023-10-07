{ lib
, stdenv
, alsa-lib
, autoPatchelfHook
, cairo
, cups
, darwin
, fontconfig
, glib
, glibc
, gtk3
, makeWrapper
, musl
, runCommandCC
, setJavaClassPath
, unzip
, xorg
, zlib
  # extra params
, extraCLibs ? [ ]
, gtkSupport ? stdenv.isLinux
, useMusl ? false
, ...
} @ args:

assert useMusl -> stdenv.isLinux;
let
  extraArgs = builtins.removeAttrs args [
    "lib"
    "stdenv"
    "alsa-lib"
    "autoPatchelfHook"
    "cairo"
    "cups"
    "darwin"
    "fontconfig"
    "glib"
    "glibc"
    "gtk3"
    "makeWrapper"
    "musl"
    "runCommandCC"
    "setJavaClassPath"
    "unzip"
    "xorg"
    "zlib"
    "extraCLibs"
    "gtkSupport"
    "useMusl"
    "passthru"
    "meta"
  ];

  cLibs = lib.optionals stdenv.isLinux (
    [ glibc zlib.static ]
    ++ lib.optionals (!useMusl) [ glibc.static ]
    ++ lib.optionals useMusl [ musl ]
    ++ extraCLibs
  );

  # GraalVM 21.3.0+ expects musl-gcc as <system>-musl-gcc
  musl-gcc = (runCommandCC "musl-gcc" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getDev musl}/bin/musl-gcc $out/bin/${stdenv.hostPlatform.system}-musl-gcc
  '');
  # GraalVM 23.0.0+ (i.e.: JDK 21.0.0+) clean-up the environment inside darwin
  # So we need to re-added some env vars to make everything work correctly again
  darwin-cc = (runCommandCC "darwin-cc"
    {
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ darwin.apple_sdk.frameworks.Foundation zlib ];
    } ''
    makeWrapper ${stdenv.cc}/bin/cc $out/bin/cc \
      --prefix NIX_CFLAGS_COMPILE_${stdenv.cc.suffixSalt} : "$NIX_CFLAGS_COMPILE" \
      --prefix NIX_LDFLAGS_${stdenv.cc.suffixSalt} : "$NIX_LDFLAGS"
  '');
  binPath = lib.makeBinPath (
    lib.optionals stdenv.isDarwin [ darwin-cc ]
    ++ lib.optionals useMusl [ musl-gcc ]
    ++ [ stdenv.cc ]
  );

  runtimeLibraryPath = lib.makeLibraryPath
    ([ cups ] ++ lib.optionals gtkSupport [ cairo glib gtk3 ]);

  graalvm-ce = stdenv.mkDerivation ({
    pname = "graalvm-ce";

    unpackPhase = ''
      runHook preUnpack

      mkdir -p "$out"

      # The tarball on Linux has the following directory structure:
      #
      #   graalvm-ce-java11-20.3.0/*
      #
      # while on Darwin it looks like this:
      #
      #   graalvm-ce-java11-20.3.0/Contents/Home/*
      #
      # We therefor use --strip-components=1 vs 3 depending on the platform.
      tar xf "$src" -C "$out" --strip-components=${
        if stdenv.isLinux then "1" else "3"
      }

      # Sanity check
      if [ ! -d "$out/bin" ]; then
        echo "The `bin` is directory missing after extracting the graalvm"
        echo "tarball, please compare the directory structure of the"
        echo "tarball with what happens in the unpackPhase (in particular"
        echo "with regards to the `--strip-components` flag)."
        exit 1
      fi

      runHook postUnpack
    '';

    dontStrip = true;

    nativeBuildInputs = [ unzip makeWrapper ]
      ++ lib.optional stdenv.isLinux autoPatchelfHook;

    propagatedBuildInputs = [ setJavaClassPath zlib ]
      ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Foundation;

    buildInputs = lib.optionals stdenv.isLinux [
      alsa-lib # libasound.so wanted by lib/libjsound.so
      fontconfig
      stdenv.cc.cc.lib # libstdc++.so.6
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
    ];

    postInstall = ''
      # jni.h expects jni_md.h to be in the header search path.
      ln -sf $out/include/linux/*_md.h $out/include/

      # copy-paste openjdk's preFixup
      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat > $out/nix-support/setup-hook << EOF
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF

      wrapProgram $out/bin/native-image \
        --prefix PATH : ${binPath} \
        ${toString (map (l: "--add-flags '-H:CLibraryPath=${l}/lib'") cLibs)}
    '';

    preFixup = lib.optionalString (stdenv.isLinux) ''
      for bin in $(find "$out/bin" -executable -type f); do
        wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
      done
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      ${# broken in darwin
      lib.optionalString stdenv.isLinux ''
        echo "Testing Jshell"
        echo '1 + 1' | $out/bin/jshell
      ''}

      echo ${lib.escapeShellArg ''
        public class HelloWorld {
          public static void main(String[] args) {
            System.out.println("Hello World");
          }
        }
      ''} > HelloWorld.java
      $out/bin/javac HelloWorld.java

      # run on JVM with Graal Compiler
      echo "Testing GraalVM"
      $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

      echo "Ahead-Of-Time compilation"
      $out/bin/native-image -H:+UnlockExperimentalVMOptions -H:-CheckToolchain -H:+ReportExceptionStackTraces HelloWorld
      ./helloworld | fgrep 'Hello World'

      ${# --static is only available in Linux
      lib.optionalString (stdenv.isLinux && !useMusl) ''
        echo "Ahead-Of-Time compilation with -H:+StaticExecutableWithDynamicLibC"
        $out/bin/native-image -H:+UnlockExperimentalVMOptions -H:+StaticExecutableWithDynamicLibC HelloWorld
        ./helloworld | fgrep 'Hello World'

        echo "Ahead-Of-Time compilation with --static"
        $out/bin/native-image --static HelloWorld
        ./helloworld | fgrep 'Hello World'
      ''}

      ${# --static is only available in Linux
      lib.optionalString (stdenv.isLinux && useMusl) ''
        echo "Ahead-Of-Time compilation with --static and --libc=musl"
        $out/bin/native-image --static HelloWorld --libc=musl
        ./helloworld | fgrep 'Hello World'
      ''}

      runHook postInstallCheck
    '';

    passthru = {
      home = graalvm-ce;
      updateScript = [ ./update.sh "graalvm-ce" ];
    } // (args.passhtru or { });

    meta = with lib; ({
      homepage = "https://www.graalvm.org/";
      description = "High-Performance Polyglot VM";
      license = with licenses; [ upl gpl2Classpath bsd3 ];
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      mainProgram = "java";
      maintainers = with maintainers; teams.graalvm-ce.members ++ [ ];
    } // (args.meta or { }));
  } // extraArgs);
in
graalvm-ce
