{ lib
, stdenv
, alsa-lib
, autoPatchelfHook
, cairo
, cups
, fontconfig
, Foundation
, glib
, gtk3
, gtkSupport ? stdenv.isLinux
, makeWrapper
, setJavaClassPath
, unzip
, xorg
, zlib
}:
{ javaVersion
, meta ? { }
, products ? [ ]
, ... } @ args:

let
  runtimeLibraryPath = lib.makeLibraryPath
    ([ cups ] ++ lib.optionals gtkSupport [ cairo glib gtk3 ]);
  mapProducts = key: default: (map (p: p.${key} or default) products);
  concatProducts = key: lib.concatStringsSep "\n" (mapProducts key "");

  graalvmXXX-ce = stdenv.mkDerivation (args // {
    pname = "graalvm${javaVersion}-ce";

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

    postUnpack = ''
      for product in ${toString products}; do
        cp -Rv $product/* $out
      done
    '';

    dontStrip = true;

    nativeBuildInputs = [ unzip makeWrapper ]
      ++ lib.optional stdenv.isLinux autoPatchelfHook;

    propagatedBuildInputs = [ setJavaClassPath zlib ]
      ++ lib.optional stdenv.isDarwin Foundation;

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

    preInstall = concatProducts "preInstall";
    postInstall = ''
      # jni.h expects jni_md.h to be in the header search path.
      ln -sf $out/include/linux/*_md.h $out/include/

      # copy-paste openjdk's preFixup
      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat > $out/nix-support/setup-hook << EOF
        if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '' + concatProducts "postInstall";

    preFixup = lib.optionalString (stdenv.isLinux) ''
      # Find all executables in any directory that contains '/bin/'
      for bin in $(find "$out" -executable -type f -wholename '*/bin/*'); do
        wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
      done
    '' + concatProducts "preFixup";
    postFixup = concatProducts "postFixup";

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      echo ${
        lib.escapeShellArg ''
          public class HelloWorld {
            public static void main(String[] args) {
              System.out.println("Hello World");
            }
          }
        ''
      } > HelloWorld.java
      $out/bin/javac HelloWorld.java

      # run on JVM with Graal Compiler
      echo "Testing GraalVM"
      $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

      ${concatProducts "installCheckPhase"}

      runHook postInstallCheck
    '';

    passthru = {
      inherit products;
      home = graalvmXXX-ce;
      updateScript = ./update.sh;
    };

    meta = with lib; ({
      inherit platforms;
      homepage = "https://www.graalvm.org/";
      description = "High-Performance Polyglot VM";
      license = with licenses; [ upl gpl2Classpath bsd3 ];
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      mainProgram = "java";
      maintainers = with maintainers; teams.graalvm-ce.members ++ [ ];
    } // meta);
  });
in graalvmXXX-ce
