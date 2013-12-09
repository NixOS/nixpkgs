{ swingSupport ? true
, stdenv
, requireFile
, unzip
, xlibs ? null
, installjdk ? true
, pluginSupport ? true
, installjce ? false
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert swingSupport -> xlibs != null;

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-linux" then
      "i386"
    else if stdenv.system == "x86_64-linux" then
      "amd64"
    else
      abort "jdk requires i686-linux or x86_64 linux";

  jce =
    if installjce then
      requireFile {
        name = "UnlimitedJCEPolicyJDK7.zip";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
        sha256 = "0qljzfxbikm8br5k7rkamibp1vkyjrf6blbxpx6hn4k46f62bhnh";
      }
    else
      null;
in

stdenv.mkDerivation {
  name =
    if installjdk then "jdk-1.7.0_45" else "jre-1.7.0_45";

  src =
    if stdenv.system == "i686-linux" then
      requireFile {
        name = "jdk-7u45-linux-i586.tar.gz";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
        sha256 = "1q0nw2rwmavcrssyigq76p1h00hm8kd3rhb5bdv7rbdcs0jxrjsa";
      }
    else if stdenv.system == "x86_64-linux" then
      requireFile {
        name = "jdk-7u45-linux-x64.tar.gz";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
        sha256 = "06jbz536zycqkdpc7zriay0jidmj9nriqva60afsgpv93kcf9spj";
      }
    else
      abort "jdk requires i686-linux or x86_64 linux";

  buildInputs = if installjce then [ unzip ] else [];

  installPhase = ''
    cd ..
    if test -z "$installjdk"; then
      mv $sourceRoot/jre $out
    else
      mv $sourceRoot $out
    fi

    for file in $out/*
    do
      if test -f $file ; then
        rm $file
      fi
    done

    if test -n "$installjdk"; then
      for file in $out/jre/*
      do
        if test -f $file ; then
          rm $file
        fi
      done
    fi

    # construct the rpath
    rpath=
    for i in $libraries; do
        rpath=$rpath''${rpath:+:}$i/lib
    done

    if test -z "$installjdk"; then
      jrePath=$out
    else
      jrePath=$out/jre
    fi

    if test -n "$jce"; then
      unzip $jce
      cp -v jce/*.jar $jrePath/lib/security
    fi

    rpath=$rpath''${rpath:+:}$jrePath/lib/${architecture}/jli

    # set all the dynamic linkers
    find $out -type f -perm +100 \
        -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    if test -z "$pluginSupport"; then
      rm -f $out/bin/javaws
      if test -n "$installjdk"; then
        rm -f $out/jre/bin/javaws
      fi
    fi

    mkdir $jrePath/lib/${architecture}/plugins
    ln -s $jrePath/lib/${architecture}/libnpjp2.so $jrePath/lib/${architecture}/plugins
  '';

  inherit installjdk pluginSupport;

  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.gcc.libc] ++
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt] else []);

  passthru.mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";

  meta.license = "unfree";
}

