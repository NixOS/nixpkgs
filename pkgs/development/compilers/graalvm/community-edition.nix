{ lib, stdenv, fetchurl, perl, unzip, glibc, zlib, setJavaClassPath, Foundation, openssl }:

let
  platform = if stdenv.isDarwin then "darwin-amd64" else "linux-amd64";
  common = javaVersion:
    let
      javaVersionPlatform = "${javaVersion}-${platform}";
      graalvmXXX-ce = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ce";
        version = "20.3.0";
        srcs = [
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "195b20ivvv8ipjn3qq2313j8qf96ji93pqm99nvn20bq23wasp25";
                        "11-linux-amd64"  = "1mdk1zhazvvh1fa01bzi5v5fxhvx592xmbakx0y1137vykbayyjm";
                         "8-darwin-amd64" = "1rrs471204p71knyxpjxymdi8ws98ph2kf5j0knk529g0d24rs01";
                        "11-darwin-amd64" = "008dl8dbf37mv4wahb9hbd6jp8svvmpy1rgsiqkn3i4hypxnkf12";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/graalvm-ce-java${javaVersionPlatform}-${version}.tar.gz";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "1rzbhllz28x5ps8n304v998hykr4m8z1gfg53ybi6laxhkbx3i13";
                        "11-linux-amd64"  = "09ipdl1489xnbckwl6sl9y7zy7kp5qf5fgf3kgz5d69jrk2z6rvf";
                         "8-darwin-amd64" = "1iy2943jbrarh8bm9wy15xk7prnskqwik2ham07a6ybp4j4b81xi";
                        "11-darwin-amd64" = "0vk2grlirghzc78kvwg66w0xriy5p8qkcp7qx83i62d7sj0kvwnf";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/native-image-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "0v98v44vblhyi3jhrngmvrkb3a6d607x4fpmrb4mrrsg75vbvc6d";
                        "11-linux-amd64"  = "0kb9472ilwqg40gyw1c4lmzkd9s763raw560sw80ljm3p75k4sc7";
                         "8-darwin-amd64" = "192n9ckr4p8qirpxr67ji3wzxpng33yfr7kxynlrcp7b3ghfic6p";
                        "11-darwin-amd64" = "1wqdk8wphywa00kl3xikiskclb84rx3nw5a4vi5y2n060kclcp22";
                      }.${javaVersionPlatform};
             url    = "https://github.com/oracle/truffleruby/releases/download/vm-${version}/ruby-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "1iskmkhrrwlhcq92g1ljvsfi9q403xxkwgzn9m282z5llh2fxv74";
                        "11-linux-amd64"  = "13bg2gs22rzbngnbw8j68jqgcknbiw30kpxac5jjcn55rf2ymvkz";
                         "8-darwin-amd64" = "08pib13q7s5wymnbykkyif66ll146vznxw4yz12qwhb419882jc7";
                        "11-darwin-amd64" = "0cb9lhc21yr2dnrm4kwa68laaczvsdnzpcbl2qix50d0v84xl602";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalpython/releases/download/vm-${version}/python-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
          (fetchurl {
             sha256 = {  "8-linux-amd64"  = "12lvcl1vmc35wh3xw5dqca7yiijsd432x4lim3knzppipy7fmflq";
                        "11-linux-amd64"  = "1s8zfgjyyw6w53974h9a2ig8a1bvc97aplyrdziywfrijgp6zkqk";
                         "8-darwin-amd64" = "06i1n42hkhcf1pfb2bly22ws4a09xgydsgh8b0kvjmb1fapd4paq";
                        "11-darwin-amd64" = "1r2bqhfxnw09izxlsc562znlp3m9c1isqzhlki083h3vp548vv9s";
                      }.${javaVersionPlatform};
             url    = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/wasm-installable-svm-java${javaVersionPlatform}-${version}.jar";
          })
        ];
        nativeBuildInputs = [ unzip perl ];
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
            echo ""
          '';
        }.${javaVersionPlatform};

        dontStrip = true;

        # copy-paste openjdk's preFixup
        preFixup = ''
          # Set JAVA_HOME automatically.
          mkdir -p $out/nix-support
          cat <<EOF > $out/nix-support/setup-hook
            if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
          EOF
        '';

        postFixup = ''
          rpath="${ {  "8" = "$out/jre/lib/amd64/jli:$out/jre/lib/amd64/server:$out/jre/lib/amd64";
                      "11" = "$out/lib/jli:$out/lib/server:$out/lib";
                    }.${javaVersion}
                 }:${
            lib.makeLibraryPath [
              stdenv.cc.cc.lib # libstdc++.so.6
              zlib             # libz.so.1
            ]}"

          ${lib.optionalString stdenv.isLinux ''
          for f in $(find $out -type f -perm -0100); do
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f" || true
            patchelf --set-rpath   "$rpath"                                    "$f" || true
            if ldd "$f" | fgrep 'not found'; then echo "in file $f"; fi
          done
          ''}
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

          # TODO: `irb` on MacOS gives an error saying "Could not find OpenSSL
          # headers, install via Homebrew or MacPorts or set OPENSSL_PREFIX", even
          # though `openssl` is in `propagatedBuildInputs`. For more details see:
          # https://github.com/NixOS/nixpkgs/pull/105815
          # echo '1 + 1' | $out/bin/irb

          echo '1 + 1' | $out/bin/node -i
        ${lib.optionalString (javaVersion == "11") ''
          echo '1 + 1' | $out/bin/jshell
        ''}'';

        passthru.home = graalvmXXX-ce;

        meta = with lib; {
          homepage = "https://www.graalvm.org/";
          description = "High-Performance Polyglot VM";
          license = with licenses; [ upl gpl2Classpath bsd3 ];
          maintainers = with maintainers; [ bandresen volth hlolli glittershark ];
          platforms = [ "x86_64-linux" "x86_64-darwin" ];
        };
      };
    in
      graalvmXXX-ce;
in {
  graalvm8-ce  = common  "8";
  graalvm11-ce = common "11";
}
