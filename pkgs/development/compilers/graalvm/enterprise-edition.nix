{ stdenv, requireFile, perl, unzip, glibc, zlib, bzip2, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsaLib, libav_0_8, setJavaClassPath }:

let
  common = javaVersion:
    let
      graalvmXXX-ee = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ee";
        version = "19.3.0.2";
        srcs = [
          (requireFile {
             name   = "graalvm-ee-java${javaVersion}-linux-amd64-${version}.tar.gz";
             sha256 = {  "8" = "0ed34a7336abec6cf854e3b2b08d4c26a492bdf221a3cf73d31b9492a21a4f9c";
                        "11" = "ebfcf47ed88a26eecf1e85a9d515bfc07d8dbaea5f2ca3139022f60c8193698a";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "native-image-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "fa48268c56b47cbb71cd6bbe7ca25800b0d87fb9be7c201ec8587a50d231f071";
                        "11" = "9e26a0cbd68470989e04749331196d403203dbf62c97154f81a11a9b8cad6969";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "python-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "c0a6bed780077e1398c43834a27d441ea459effd92d27802ab8229b3f229b76d";
                        "11" = "218bd9c4050e72be34de3d48bada305691fcb36e367a24871223e89f2c3067be";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "ruby-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "76c776b8d2e61232e7d9ad8fcbe9d098908b62fec383288c07b7e37c2d6941c4";
                        "11" = "f9a92ab69866edc4da6e2d906525a5bdd297f9ae0b01177c6752206343aefded";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
        ];
        nativeBuildInputs = [ unzip perl ];
        unpackPhase = ''
          unpack_jar() {
            jar=$1
            unzip $jar -d $out
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
          tar xf ''${arr[0]} -C $out --strip-components=1
          unpack_jar ''${arr[1]}
          unpack_jar ''${arr[2]}
          unpack_jar ''${arr[3]}
        '';

        installPhase = {
          "8" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/jre/lib/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/jre/lib/svm/clibraries/linux-amd64/$(basename $f)
            done

            # allow using external truffle-api.jar and languages not included in the distrubution
            rm $out/jre/lib/jvmci/parentClassLoader.classpath
          '';
          "11" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/conf/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/lib/svm/clibraries/linux-amd64/$(basename $f)
            done
           '';
        }.${javaVersion};

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
            stdenv.lib.strings.makeLibraryPath [ glibc xorg.libXxf86vm xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender
                                                 glib zlib bzip2 alsaLib fontconfig freetype pango gtk3 gtk2 cairo gdk-pixbuf atk ffmpeg libGL ]}"

          for f in $(find $out -type f -perm -0100); do
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f" || true
            patchelf --set-rpath   "$rpath"                                    "$f" || true
          done

          for f in $(find $out -type f -perm -0100); do
            if ldd "$f" | fgrep 'not found'; then echo "in file $f"; fi
          done
        '';

        propagatedBuildInputs = [ setJavaClassPath zlib ]; # $out/bin/native-image needs zlib to build native executables

        doInstallCheck = true;
        installCheckPhase = ''
          echo ${stdenv.lib.escapeShellArg ''
                   public class HelloWorld {
                     public static void main(String[] args) {
                       System.out.println("Hello World");
                     }
                   }
                 ''} > HelloWorld.java
          $out/bin/javac HelloWorld.java

          # run on JVM with Graal Compiler
          $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld
          $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

          # Ahead-Of-Time compilation
          $out/bin/native-image --no-server HelloWorld
          ./helloworld
          ./helloworld | fgrep 'Hello World'

          # Ahead-Of-Time compilation with --static
          $out/bin/native-image --no-server --static HelloWorld
          ./helloworld
          ./helloworld | fgrep 'Hello World'
        '';

        passthru.home = graalvmXXX-ee;

        meta = with stdenv.lib; {
          homepage = https://www.graalvm.org/;
          description = "High-Performance Polyglot VM";
          license = licenses.unfree;
          maintainers = with maintainers; [ volth hlolli ];
          platforms = [ "x86_64-linux" ];
        };
      };
    in
      graalvmXXX-ee;
in {
  graalvm8-ee  = common  "8";
  graalvm11-ee = common "11";
}
