{ lib, stdenv, requireFile, perl, unzip, glibc, zlib, bzip2, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsa-lib, setJavaClassPath }:

let
  common = javaVersion:
    let
      graalvmXXX-ee = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ee";
        version = "20.2.1";
        srcs = [
          (requireFile {
             name   = "graalvm-ee-java${javaVersion}-linux-amd64-${version}.tar.gz";
             sha256 = {  "8" = "e0bb182146283a43824dd2c2ceeb89b6ff7a93f9a85da889f8663ce1c2bd3002";
                        "11" = "e5d92d361e7859fe5f88c92d7bb466e285e07f1e4e2d9944948f85fa0e3aee2b";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "native-image-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "37ac6a62f68adad513057a60513ba75749adf98cc73999b3918afe159900428d";
                        "11" = "f62df715ad529f8b84854644ac99e0a9a349232c7f03985d20a2a8be20edaa44";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "llvm-toolchain-installable-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "da98a8c17b0c724b41d1596b57e282a1ecfcbf9140404dfb04b0d4d9fb159d8a";
                        "11" = "fc442c396e92f59d034a69175104cb3565c3d128426bd939cc94c6ceccbb720f";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "ruby-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "44f6887249f2eb54cba98dd4d9de019da5463d92982e03bf655fffe4bb520daf";
                        "11" = "941f3752ccb097958f49250586f04c305092ded3ea4c1b7d9a0f7632e47fa335";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "python-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "5c3993c701bd09c6064dcf4a6d9c7489620d0654b03c74682398c788c0211c09";
                        "11" = "de3ebf35ce47dc399d7976cbd09fde0e85f2c10f85bc3fe8f32bb9e2b500ab70";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "wasm-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "c0a334b271fd32c098bb3c42eada7eafb9f536becaa756097eebe4682915b067";
                        "11" = "9e801071992a0ff976bc40b640a8b9368fd8ea890ba986543658fcbaa3a7fd68";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
        ];
        nativeBuildInputs = [ unzip perl ];
        unpackPhase = ''
          unpack_jar() {
            jar=$1
            unzip -o $jar -d $out
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
          unpack_jar ''${arr[4]}
          unpack_jar ''${arr[5]}
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
            lib.strings.makeLibraryPath [ glibc xorg.libXxf86vm xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender
                                                 glib zlib bzip2 alsa-lib fontconfig freetype pango gtk3 gtk2 cairo gdk-pixbuf atk ffmpeg libGL ]}"

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
          echo ${lib.escapeShellArg ''
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

        meta = with lib; {
          homepage = "https://www.graalvm.org/";
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
