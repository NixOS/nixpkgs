{ version, javaVersion, platforms, hashes ? import ./hashes.nix }:

{ stdenv, lib, fetchurl, autoPatchelfHook, setJavaClassPath, makeWrapper
# minimum dependencies
, Foundation, alsa-lib, fontconfig, freetype, glibc, openssl, perl, unzip, xorg
, zlib
# runtime dependencies
, cups
# runtime dependencies for GTK+ Look and Feel
, gtkSupport ? true, cairo, glib, gtk3 }:

let
  platform = {
    aarch64-linux = "linux-aarch64";
    x86_64-linux = "linux-amd64";
    x86_64-darwin = "darwin-amd64";
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  runtimeDependencies = [ cups ]
    ++ lib.optionals gtkSupport [ cairo glib gtk3 ];

  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;

  javaVersionPlatform = "${javaVersion}-${platform}";

  graalvmXXX-ce = stdenv.mkDerivation rec {
    inherit version;
    name = "graalvm${javaVersion}-ce";
    srcs =
      let
        # Some platforms doesn't have all GraalVM features
        # e.g.: GraalPython on aarch64-linux
        # When the platform doesn't have a feature, sha256 is null on hashes.nix
        # To update hashes.nix file, run `./update.sh <graalvm-ce-version>`
        maybeFetchUrl = url: if url.sha256 != null then (fetchurl url) else null;
      in
      (lib.remove null
        (map maybeFetchUrl (hashes { inherit javaVersionPlatform; })));

    buildInputs = lib.optionals stdenv.isLinux [
      alsa-lib # libasound.so wanted by lib/libjsound.so
      fontconfig
      freetype
      openssl # libssl.so wanted by languages/ruby/lib/mri/openssl.so
      stdenv.cc.cc.lib # libstdc++.so.6
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      zlib
    ];

    # Workaround for libssl.so.10 wanted by TruffleRuby
    # Resulting TruffleRuby cannot use `openssl` library.
    autoPatchelfIgnoreMissingDeps = true;

    nativeBuildInputs = [ unzip perl autoPatchelfHook makeWrapper ];

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

    installPhase = let
      copyClibrariesToOut = basepath: ''
        # provide libraries needed for static compilation
        for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
          ln -s $f ${basepath}/${platform}/$(basename $f)
        done
      '';
      copyClibrariesToLib = ''
        # add those libraries to $lib output too, so we can use them with
        # `native-image -H:CLibraryPath=''${graalvm11-ce.lib}/lib ...` and reduce
        # closure size by not depending on GraalVM $out (that is much bigger)
        mkdir -p $lib/lib
        for f in ${glibc}/lib/*; do
          ln -s $f $lib/lib/$(basename $f)
        done
      '';
    in {
      "11-linux-amd64" = ''
        ${copyClibrariesToOut "$out/lib/svm/clibraries"}

        ${copyClibrariesToLib}
      '';
      "17-linux-amd64" = ''
        ${copyClibrariesToOut "$out/lib/svm/clibraries"}

        ${copyClibrariesToLib}
      '';
      "11-linux-aarch64" = ''
        ${copyClibrariesToOut "$out/lib/svm/clibraries"}

        ${copyClibrariesToLib}
      '';
      "17-linux-aarch64" = ''
        ${copyClibrariesToOut "$out/lib/svm/clibraries"}

        ${copyClibrariesToLib}
      '';
      "11-darwin-amd64" = "";
      "17-darwin-amd64" = "";
    }.${javaVersionPlatform} + ''
      # ensure that $lib/lib exists to avoid breaking builds
      mkdir -p $lib/lib
      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/
    '';

    dontStrip = true;

    preFixup = ''
      # We cannot use -exec since wrapProgram is a function but not a
      # command.
      #
      # jspawnhelper is executed from JVM, so it doesn't need to wrap it,
      # and it breaks building OpenJDK (#114495).
      for bin in $( find "$out" -executable -type f -not -path '*/languages/ruby/lib/gems/*' -not -name jspawnhelper ); do
        if patchelf --print-interpreter "$bin" &> /dev/null || head -n 1 "$bin" | grep '^#!' -q; then
          wrapProgram "$bin" \
            --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
        fi
      done

      # copy-paste openjdk's preFixup
      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
        if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF

      find "$out" -name libfontmanager.so -exec \
        patchelf --add-needed libfontconfig.so {} \;
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

      # Ahead-Of-Time compilation
      $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces --no-server HelloWorld
      ./helloworld | fgrep 'Hello World'

      ${
        lib.optionalString stdenv.isLinux ''
          # Ahead-Of-Time compilation with --static
          # --static flag doesn't work for darwin
          $out/bin/native-image --no-server --static HelloWorld
          ./helloworld | fgrep 'Hello World'
        ''
      }

      ${# TODO: Doesn't work on MacOS, we have this error:
        # "Launching JShell execution engine threw: Operation not permitted (Bind failed)"
        lib.optionalString (stdenv.isLinux) ''
          echo "Testing Jshell"
          echo '1 + 1' | $out/bin/jshell
        ''
      }

      ${
        lib.optionalString (platform != "linux-aarch64") ''
          echo "Testing GraalPython"
          $out/bin/graalpython -c 'print(1 + 1)'
          echo '1 + 1' | $out/bin/graalpython
        ''
      }

      echo "Testing TruffleRuby"
      # Hide warnings about wrong locale
      export LANG=C
      export LC_ALL=C
      $out/bin/ruby -e 'puts(1 + 1)'
      ${# FIXME: irb is broken in all platforms
        # TODO: `irb` on MacOS gives an error saying "Could not find OpenSSL
        # headers, install via Homebrew or MacPorts or set OPENSSL_PREFIX", even
        # though `openssl` is in `propagatedBuildInputs`. For more details see:
        # https://github.com/NixOS/nixpkgs/pull/105815
        # TODO: "truffleruby: an internal exception escaped out of the interpreter"
        # error on linux-aarch64
        # TODO: "core/kernel.rb:234:in `gem_original_require':
        # /nix/store/wlc5xalzj2ip1l83siqw8ac5fjd52ngm-graalvm11-ce/languages/llvm/native/lib:
        # cannot read file data: Is a directory (RuntimeError)" error on linux-amd64
        lib.optionalString false ''
          echo '1 + 1' | $out/bin/irb
        ''
      }
    '';

    passthru = {
      home = graalvmXXX-ce;
      updateScript = ./update.sh;
    };

    meta = with lib; {
      inherit platforms;
      homepage = "https://www.graalvm.org/";
      description = "High-Performance Polyglot VM";
      license = with licenses; [ upl gpl2Classpath bsd3 ];
      maintainers = with maintainers; [
        bandresen
        volth
        hlolli
        glittershark
        babariviere
        ericdallo
        thiagokokada
      ];
    };
  };
in graalvmXXX-ce
