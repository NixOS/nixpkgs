{ stdenv, requireFile, perl, unzip, glibc, zlib, bzip2, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsaLib, libav_0_8, setJavaClassPath }:

let
  common = javaVersion:
    let
      graalvmXXX-ee = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ee";
        version = "19.3.0";
        srcs = [
          (requireFile {
             name   = "graalvm-ee-java${javaVersion}-linux-amd64-${version}.tar.gz";
             sha256 = {  "8" = "dae766424457faea3bd2d7179477bab8dc073d92755ad09c51eee55ce5cb8b78";
                        "11" = "aced0251642e942081aa386a05656bab84984999ced296b4e001ae982ac3842d";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "native-image-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "92fc421c8a07c7794179c96489ddf29d755d0a81ead2056fbf47fa137dbefc69";
                        "11" = "fe6363ecfe919d3575607276ac6541a4f0d29cd740424b3ea7fadd26c5915106";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "python-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "2668c44a6939393983fd941fc1c5573f49a349fc0cf919f6cd0ae98b7e8fac56";
                        "11" = "f148e1c2b78614b77ffc8c4292f62f21377e67f7359b8505fe6331d41e5a1a75";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "ruby-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "e5f5938b9f55bde3f8b4e0f48f52cbb79a8668b53bbf96ab89b1da8d85bdfa90";
                        "11" = "2481b6e2644d302c190a898e58a21cda1aa32e473d12775217a6dd4d919413ea";
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
