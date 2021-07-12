{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, setJavaClassPath
, makeWrapper
# minimum dependencies
, Foundation
, alsa-lib
, fontconfig
, freetype
, glibc
, openssl
, perl
, unzip
, xorg
, zlib
# runtime dependencies
, cups
# runtime dependencies for GTK+ Look and Feel
, gtkSupport ? true
, cairo
, glib
, gtk3
}:

let
  platform = if stdenv.isDarwin then "darwin-amd64" else "linux-amd64";
  runtimeDependencies = [
    cups
  ] ++ lib.optionals gtkSupport [
    cairo glib gtk3
  ];
  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;
  common = javaVersion:
    let
      javaVersionPlatform = "${javaVersion}-${platform}";
      graalvmXXX-ce = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ce";
        version = "21.0.0";
        srcs = [
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "18q1plrpclp02rlwn3vvv2fcyspvqv2gkzn14f0b59pnladmlv1j";
                        "11-linux-amd64"  = "1g1xjbr693rimdy2cy6jvz4vgnbnw76wa87xcmaszka206fmpnsc";
                         "8-darwin-amd64" = "0giv8f7ybdykadzmxjy91i6njbdx6dclyx7g6vyhwk2l1cvxi4li";
                        "11-darwin-amd64" = "1a8gjp6fp11ms05pd62h1x1ifkkr3wv0hrxic670v90bbps9lsqf";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/graalvm-ce-java${javaVersionPlatform}-${version}.tar.gz";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "0hpq2g9hc8b7j4d8a08kq1mnl6pl7a4kwaj0a3gka3d4m6r7cscg";
                        "11-linux-amd64"  = "0z3hb2bf0lqzw760civ3h1wvx22a75n7baxc0l2i9h5wxas002y7";
                         "8-darwin-amd64" = "1izbgl4hjg5jyi422xnkx006qnw163r1i1djf76q1plms40y01ph";
                        "11-darwin-amd64" = "1d9z75gil0if74ndla9yw3xx9i2bfbcs32qa0z6wi5if66cmknb8";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/native-image-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "122p8psgmzhqnjb2fy1lwghg0kw5qa8xkzgyjp682lwg4j8brz43";
                        "11-linux-amd64"  = "1vdc90m6s013cbhmj58nb4vyxllbxirw0idlgv0iv9cyhx90hzgz";
                         "8-darwin-amd64" = "04q0s9xsaskqn9kbhz0mgdk28j2qnxrzqfmw6jn2znr8s8jsc6yp";
                        "11-darwin-amd64" = "1pw4xd8g5cc9bm52awmm1zxs96ijws43vws7y10wxa6a0nhv7z5f";
                      }.${javaVersionPlatform};
             url    = "https://github.com/oracle/truffleruby/releases/download/vm-${version}/ruby-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "19m7n4f5jrmsfvgv903sarkcjh55l0nlnw99lvjlcafw5hqzyb91";
                        "11-linux-amd64"  = "18ibb7l7b4hmbnvyr8j7mrs11mvlsf2j0c8rdd2s93x2114f26ba";
                         "8-darwin-amd64" = "1zlzi00339kvg4ym2j75ypfkzn8zbwdpriqmkaz4fh28qjmc1dwq";
                        "11-darwin-amd64" = "0x301i1fimakhi2x29ldr0fsqkb3qs0g9jsmjv27d62dpqx8kgc8";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalpython/releases/download/vm-${version}/python-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "0dlgbg6kri89r9zbk6n0ch3g8356j1g35bwjng87c2y5y0vcw0b5";
                        "11-linux-amd64"  = "1yby65hww6zmd2g5pjwbq5pv3iv4gfv060b8fq75fjhwrisyj5gd";
                         "8-darwin-amd64" = "1smdj491g23i3z7p5rybid18nnz8bphrqjkv0lg2ffyrpn8k6g93";
                        "11-darwin-amd64" = "056zyn0lpd7741k1szzjwwacka0g7rn0j4ypfmav4h1245mjg8lx";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/wasm-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
        ];

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
           tar xf ''${arr[0]} -C $out --strip-components=${if stdenv.isLinux then "1" else "3"}

           # Sanity check
           if [ ! -d $out/bin ]; then
              echo "The `bin` is directory missing after extracting the graalvm"
              echo "tarball, please compare the directory structure of the"
              echo "tarball with what happens in the unpackPhase (in particular"
              echo "with regards to the `--strip-components` flag)."
              exit 1
           fi

           unpack_jar ''${arr[1]}
           unpack_jar ''${arr[2]}
           unpack_jar ''${arr[3]}
           unpack_jar ''${arr[4]}
        '';

        installPhase = {
          "8-linux-amd64" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/jre/lib/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/jre/lib/svm/clibraries/${platform}/$(basename $f)
            done

            # allow using external truffle-api.jar and languages not included in the distrubution
            rm $out/jre/lib/jvmci/parentClassLoader.classpath
          '';
          "11-linux-amd64" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/conf/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/lib/svm/clibraries/${platform}/$(basename $f)
            done
          '';
          "8-darwin-amd64" = ''
            # allow using external truffle-api.jar and languages not included in the distrubution
            rm $out/jre/lib/jvmci/parentClassLoader.classpath
          '';
          "11-darwin-amd64" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/conf/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG
          '';
        }.${javaVersionPlatform};

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
          echo ${lib.escapeShellArg ''
                   public class HelloWorld {
                     public static void main(String[] args) {
                       System.out.println("Hello World");
                     }
                   }
                 ''} > HelloWorld.java
          $out/bin/javac HelloWorld.java

          # run on JVM with Graal Compiler
          $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

          # Ahead-Of-Time compilation
          $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces --no-server HelloWorld
          ./helloworld | fgrep 'Hello World'

          ${lib.optionalString stdenv.isLinux ''
            # Ahead-Of-Time compilation with --static
            # --static flag doesn't work for darwin
            $out/bin/native-image --no-server --static HelloWorld
            ./helloworld | fgrep 'Hello World'
          ''}

          echo "Testing interpreted languages"
          $out/bin/graalpython -c 'print(1 + 1)'
          $out/bin/ruby -e 'puts(1 + 1)'
          $out/bin/node -e 'console.log(1 + 1)'

          echo '1 + 1' | $out/bin/graalpython

          ${lib.optionalString stdenv.isLinux ''
            # TODO: `irb` on MacOS gives an error saying "Could not find OpenSSL
            # headers, install via Homebrew or MacPorts or set OPENSSL_PREFIX", even
            # though `openssl` is in `propagatedBuildInputs`. For more details see:
            # https://github.com/NixOS/nixpkgs/pull/105815
            echo '1 + 1' | $out/bin/irb
          ''}

          echo '1 + 1' | $out/bin/node -i
        ${lib.optionalString (javaVersion == "11" && stdenv.isLinux) ''
          # Doesn't work on MacOS, we have this error: "Launching JShell execution engine threw: Operation not permitted (Bind failed)"
          echo '1 + 1' | $out/bin/jshell
        ''}'';

        passthru.home = graalvmXXX-ce;

        meta = with lib; {
          homepage = "https://www.graalvm.org/";
          description = "High-Performance Polyglot VM";
          license = with licenses; [ upl gpl2Classpath bsd3 ];
          maintainers = with maintainers; [ bandresen volth hlolli glittershark babariviere ];
          platforms = [ "x86_64-linux" "x86_64-darwin" ];
        };
      };
    in
      graalvmXXX-ce;
in {
  graalvm8-ce  = common  "8";
  graalvm11-ce = common "11";
}
