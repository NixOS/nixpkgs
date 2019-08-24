{ stdenv, requireFile, perl, unzip, glibc, zlib, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsaLib, libav_0_8, setJavaClassPath }:

let
  graalvm8-ee = stdenv.mkDerivation rec {
    pname = "graalvm8-ee";
    version = "19.2.0";
    srcs = [
      (requireFile {
         name   = "graalvm-ee-linux-amd64-${version}.tar.gz";
         sha256 = "1j56lyids48zyjhxk8xl4niy8hk6qzi1aj7c55yfh62id8v6cpbw";
         url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
      })
      (requireFile {
         name   = "native-image-installable-svm-svmee-linux-amd64-${version}.jar";
         sha256 = "07c25l27msxccqrbz4bknz0sxsl0z2k8990cdfkbrgxvhxspfnnm";
         url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
      })
      (requireFile {
         name   = "python-installable-svm-svmee-linux-amd64-${version}.jar";
         sha256 = "1c7kpz56w9p418li97ymixdwywscr85vhn7jkzxq71bj7ia7pxwz";
         url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
      })
      (requireFile {
         name   = "ruby-installable-svm-svmee-linux-amd64-${version}.jar";
         sha256 = "13jfm5qpxqxz7f5n9yyvqrv1vwigifrjwk3hssp23maski2ssys1";
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

    installPhase = ''
      # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
      substituteInPlace $out/jre/lib/security/java.security \
        --replace file:/dev/random    file:/dev/./urandom \
        --replace NativePRNGBlocking  SHA1PRNG

      # provide libraries needed for static compilation
      for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
        ln -s $f $out/jre/lib/svm/clibraries/linux-amd64/$(basename $f)
      done
    '';

    dontStrip = true;

    preFixup = ''
      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
      if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    postFixup = ''
      rpath="$out/jre/lib/amd64/jli:$out/jre/lib/amd64/server:$out/jre/lib/amd64:${
        stdenv.lib.strings.makeLibraryPath [ glibc xorg.libXxf86vm xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender
                                             glib zlib alsaLib fontconfig freetype pango gtk3 gtk2 cairo gdk-pixbuf atk ffmpeg libGL ]}"

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

    passthru.home = graalvm8-ee;

    meta = with stdenv.lib; {
      homepage = https://www.graalvm.org/;
      description = "High-Performance Polyglot VM";
      license = licenses.unfree;
      maintainers = with maintainers; [ volth hlolli ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
  graalvm8-ee
