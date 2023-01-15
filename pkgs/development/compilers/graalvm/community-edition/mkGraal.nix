{
  # An attrset describing each platform configuration. All values are extract
  # from the GraalVM releases available on
  # https://github.com/graalvm/graalvm-ce-builds/releases
  # Example:
  # config = {
  #   x86_64-linux = {
  #     # List of products that will be included in the GraalVM derivation
  #     # See `with{NativeImage,Ruby,Python,WASM,*}Svm` variables for the
  #     # available values
  #     products = [ "graalvm-ce" "native-image-installable-svm" ];
  #     # GraalVM arch, not to be confused with the nix platform
  #     arch = "linux-amd64";
  #     # GraalVM version
  #     version = "22.0.0.2";
  #   };
  # }
  config
  # GraalVM version that will be used unless overridden by `config.<platform>.version`
, defaultVersion
  # Java version used by GraalVM
, javaVersion
  # Platforms were GraalVM will be allowed to build (i.e. `meta.platforms`)
, platforms ? builtins.attrNames config
  # If set to true, update script will (re-)generate the sources file even if
  # there are no updates available
, forceUpdate ? false
  # Path for the sources file that will be used
  # See `update.nix` file for a description on how this file works
, sourcesPath ? ./. + "/graalvm${javaVersion}-ce-sources.json"
  # Use musl instead of glibc to allow true static builds in GraalVM's
  # Native Image (i.e.: `--static --libc=musl`). This will cause glibc static
  # builds to fail, so it should be used with care
, useMusl ? false
}:

{ stdenv
, lib
, autoPatchelfHook
, fetchurl
, makeWrapper
, setJavaClassPath
, writeShellScriptBin
  # minimum dependencies
, alsa-lib
, fontconfig
, Foundation
, freetype
, glibc
, openssl
, perl
, unzip
, xorg
, zlib
  # runtime dependencies
, binutils
, cups
, gcc
, musl
  # runtime dependencies for GTK+ Look and Feel
, gtkSupport ? stdenv.isLinux
, cairo
, glib
  # updateScript deps
, gnused
, gtk3
, jq
, writeShellScript
}:

assert useMusl -> stdenv.isLinux;

let
  platform = config.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  version = platform.version or defaultVersion;
  name = "graalvm${javaVersion}-ce";
  sources = builtins.fromJSON (builtins.readFile sourcesPath);

  runtimeLibraryPath = lib.makeLibraryPath
    ([ cups ] ++ lib.optionals gtkSupport [ cairo glib gtk3 ]);

  runtimeDependencies = lib.makeBinPath ([
    binutils
    stdenv.cc
  ] ++ lib.optionals useMusl [
    (lib.getDev musl)
    # GraalVM 21.3.0+ expects musl-gcc as <system>-musl-gcc
    (writeShellScriptBin "${stdenv.hostPlatform.system}-musl-gcc" ''${lib.getDev musl}/bin/musl-gcc "$@"'')
  ]);

  withNativeImageSvm = builtins.elem "native-image-installable-svm" platform.products;
  withRubySvm = builtins.elem "ruby-installable-svm" platform.products;
  withPythonSvm = builtins.elem "python-installable-svm" platform.products;
  withWasmSvm = builtins.elem "wasm-installable-svm" platform.products;

  graalvmXXX-ce = stdenv.mkDerivation rec {
    inherit version;
    pname = name;

    srcs = map fetchurl (builtins.attrValues sources.${platform.arch});

    buildInputs = lib.optionals stdenv.isLinux [
      alsa-lib # libasound.so wanted by lib/libjsound.so
      fontconfig
      freetype
      stdenv.cc.cc.lib # libstdc++.so.6
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      zlib
    ] ++ lib.optionals withRubySvm [
      openssl # libssl.so wanted by languages/ruby/lib/mri/openssl.so
    ];

    nativeBuildInputs = [ unzip perl makeWrapper ]
      ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

    unpackPhase = ''
      unpack_jar() {
        jar=$1
        unzip -q -o $jar -d $out
        perl -ne 'use File::Path qw(make_path);
                  use File::Basename qw(dirname);
                  if (/^(.+) = (.+)$/) {
                    make_path dirname("$ENV{out}/$1");
                    system "ln -s $2 $ENV{out}/$1";
                  }' $out/META-INF/symlinks
        perl -ne 'if (/^(.+) = ([r-])([w-])([x-])([r-])([w-])([x-])([r-])([w-])([x-])$/) {
                    my $mode = ($2 eq 'r' ? 0400 : 0) + ($3 eq 'w' ? 0200 : 0) + ($4  eq 'x' ? 0100 : 0) +
                               ($5 eq 'r' ? 0040 : 0) + ($6 eq 'w' ? 0020 : 0) + ($7  eq 'x' ? 0010 : 0) +
                               ($8 eq 'r' ? 0004 : 0) + ($9 eq 'w' ? 0002 : 0) + ($10 eq 'x' ? 0001 : 0);
                    chmod $mode, "$ENV{out}/$1";
                  }' $out/META-INF/permissions
        rm -rf $out/META-INF
      }

      mkdir -p $out
      arr=($srcs)

      # The tarball on Linux has the following directory structure:
      #
      #   graalvm-ce-java11-20.3.0/*
      #
      # while on Darwin it looks like this:
      #
      #   graalvm-ce-java11-20.3.0/Contents/Home/*
      #
      # We therefor use --strip-components=1 vs 3 depending on the platform.
      tar xf ''${arr[0]} -C $out --strip-components=${
        if stdenv.isLinux then "1" else "3"
      }

      # Sanity check
      if [ ! -d $out/bin ]; then
         echo "The `bin` is directory missing after extracting the graalvm"
         echo "tarball, please compare the directory structure of the"
         echo "tarball with what happens in the unpackPhase (in particular"
         echo "with regards to the `--strip-components` flag)."
         exit 1
      fi

      for jar in "''${arr[@]:1}"; do
        unpack_jar "$jar"
      done
    '';

    outputs = [ "out" "lib" ];

    installPhase = ''
      # ensure that $lib/lib exists to avoid breaking builds
      mkdir -p "$lib/lib"
      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # copy-paste openjdk's preFixup
      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat > $out/nix-support/setup-hook << EOF
        if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
      ${
        lib.optionalString (stdenv.isLinux) ''
          # provide libraries needed for static compilation
          ${
            if useMusl then
              ''for f in "${musl.stdenv.cc.cc}/lib/"* "${musl}/lib/"* "${zlib.static}/lib/"*; do''
            else
              ''for f in "${glibc}/lib/"* "${glibc.static}/lib/"* "${zlib.static}/lib/"*; do''
          }
            ln -s "$f" "$out/lib/svm/clibraries/${platform.arch}/$(basename $f)"
          done

          # add those libraries to $lib output too, so we can use them with
          # `native-image -H:CLibraryPath=''${lib.getLib graalvmXX-ce}/lib ...` and reduce
          # closure size by not depending on GraalVM $out (that is much bigger)
          # we always use glibc here, since musl is only supported for static compilation
          for f in "${glibc}/lib/"*; do
            ln -s "$f" "$lib/lib/$(basename $f)"
          done
        ''
      }
    '';

    dontStrip = true;

    # Workaround for libssl.so.10 wanted by TruffleRuby
    # Resulting TruffleRuby cannot use `openssl` library.
    autoPatchelfIgnoreMissingDeps = withRubySvm && stdenv.isDarwin;

    preFixup = lib.optionalString (stdenv.isLinux) ''
      # Find all executables in any directory that contains '/bin/'
      for bin in $(find "$out" -executable -type f -wholename '*/bin/*'); do
        wrapProgram "$bin" \
          --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}" \
          --prefix PATH : "${runtimeDependencies}"
      done

      find "$out" -name libfontmanager.so -exec \
        patchelf --add-needed libfontconfig.so {} \;

      ${
        lib.optionalString withRubySvm ''
          # Workaround for libssl.so.10/libcrypto.so.10 wanted by TruffleRuby
          patchelf $out/languages/ruby/lib/mri/openssl.so \
            --replace-needed libssl.so.10 libssl.so \
            --replace-needed libcrypto.so.10 libcrypto.so
        ''
      }
    '';

    # $out/bin/native-image needs zlib to build native executables.
    propagatedBuildInputs = [ setJavaClassPath zlib ] ++
      # On Darwin native-image calls clang and it
      # tries to include <Foundation/Foundation.h>,
      # and Interactive Ruby (irb) requires OpenSSL
      # headers.
      lib.optionals stdenv.hostPlatform.isDarwin [ Foundation openssl ];

    doInstallCheck = true;
    installCheckPhase = ''
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
      $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

      ${# --static flag doesn't work for darwin
        lib.optionalString (withNativeImageSvm && stdenv.isLinux && !useMusl) ''
          echo "Ahead-Of-Time compilation"
          $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces --no-server HelloWorld
          ./helloworld | fgrep 'Hello World'

          echo "Ahead-Of-Time compilation with --static"
          $out/bin/native-image --no-server --static HelloWorld
          ./helloworld | fgrep 'Hello World'
        ''
      }

      ${# --static flag doesn't work for darwin
        lib.optionalString (withNativeImageSvm && stdenv.isLinux && useMusl) ''
          echo "Ahead-Of-Time compilation with --static and --libc=musl"
          $out/bin/native-image --no-server --libc=musl --static HelloWorld
          ./helloworld | fgrep 'Hello World'
        ''
      }

      ${
        lib.optionalString withWasmSvm ''
          echo "Testing Jshell"
          echo '1 + 1' | $out/bin/jshell
        ''
      }

      ${
        lib.optionalString withPythonSvm ''
          echo "Testing GraalPython"
          $out/bin/graalpython -c 'print(1 + 1)'
          echo '1 + 1' | $out/bin/graalpython
        ''
      }

      ${
        lib.optionalString withRubySvm ''
          echo "Testing TruffleRuby"
          # Hide warnings about wrong locale
          export LANG=C
          export LC_ALL=C
          $out/bin/ruby -e 'puts(1 + 1)'
        ''
        # FIXME: irb is broken in all platforms
        + lib.optionalString false ''
          echo '1 + 1' | $out/bin/irb
        ''
      }
    '';

    passthru = {
      inherit (platform) products;
      home = graalvmXXX-ce;
      updateScript = import ./update.nix {
        inherit config defaultVersion forceUpdate gnused jq lib name sourcesPath writeShellScript;
        graalVersion = version;
        javaVersion = "java${javaVersion}";
      };
    };

    meta = with lib; {
      inherit platforms;
      homepage = "https://www.graalvm.org/";
      description = "High-Performance Polyglot VM";
      license = with licenses; [ upl gpl2Classpath bsd3 ];
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      mainProgram = "java";
      maintainers = with maintainers; [
        bandresen
        hlolli
        glittershark
        babariviere
        ericdallo
        thiagokokada
      ];
    };
  };
in
graalvmXXX-ce
