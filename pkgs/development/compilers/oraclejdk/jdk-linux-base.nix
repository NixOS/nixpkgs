{ productVersion
, patchVersion
, sha256
, jceName
, sha256JCE
}:

{ swingSupport ? true
, stdenv
, requireFile
, makeWrapper
, unzip
, file
, xorg ? null
, installjdk ? true
, pluginSupport ? true
, installjce ? false
, config
, glib
, libxml2
, libav_0_8
, ffmpeg
, libxslt
, libGL
, freetype
, fontconfig
, gtk2
, pango
, cairo
, alsaLib
, atk
, gdk-pixbuf
, setJavaClassPath
}:

assert swingSupport -> xorg != null;

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture = {
    i686-linux    = "i386";
    x86_64-linux  = "amd64";
    armv7l-linux  = "arm";
    aarch64-linux = "aarch64";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  jce =
    if installjce then
      requireFile {
        name = jceName;
        url = "http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html";
        sha256 = sha256JCE;
      }
    else
      "";

  rSubPaths = [
    "lib/${architecture}/jli"
    "lib/${architecture}/server"
    "lib/${architecture}/xawt"
    "lib/${architecture}"
  ];

in

let result = stdenv.mkDerivation rec {
  pname = if installjdk then "oraclejdk" else "oraclejre";
  version = "${productVersion}u${patchVersion}";

  src =
    let
      platformName = {
        i686-linux    = "linux-i586";
        x86_64-linux  = "linux-x64";
        armv7l-linux  = "linux-arm32-vfp-hflt";
        aarch64-linux = "linux-arm64-vfp-hflt";
      }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
    in requireFile {
      name = "jdk-${productVersion}u${patchVersion}-${platformName}.tar.gz";
      url = "http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html";
      sha256 = sha256.${stdenv.hostPlatform.system};
    };

  nativeBuildInputs = [ file ]
    ++ stdenv.lib.optional installjce unzip;

  buildInputs = [ makeWrapper ];

  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase = ''
    cd ..

    if test -z "$installjdk"; then
      mv $sourceRoot/jre $out
    else
      mv $sourceRoot $out
    fi

    shopt -s extglob
    for file in $out/!(*src.zip)
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

    if test -z "$installjdk"; then
      jrePath=$out
    else
      jrePath=$out/jre
    fi

    if test -n "${jce}"; then
      unzip ${jce}
      cp -v UnlimitedJCEPolicy*/*.jar $jrePath/lib/security
    fi

    if test -z "$pluginSupport"; then
      rm -f $out/bin/javaws
      if test -n "$installjdk"; then
        rm -f $out/jre/bin/javaws
      fi
    fi

    mkdir $jrePath/lib/${architecture}/plugins
    ln -s $jrePath/lib/${architecture}/libnpjp2.so $jrePath/lib/${architecture}/plugins

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  postFixup = ''
    rpath+="''${rpath:+:}${stdenv.lib.concatStringsSep ":" (map (a: "$jrePath/${a}") rSubPaths)}"

    # set all the dynamic linkers
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    # Oracle Java Mission Control needs to know where libgtk-x11 and related is
    if test -n "$installjdk" -a -x $out/bin/jmc; then
      wrapProgram "$out/bin/jmc" \
          --suffix-each LD_LIBRARY_PATH ':' "$rpath"
    fi
  '';

  inherit installjdk pluginSupport;

  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt libGL xorg.libXxf86vm alsaLib fontconfig freetype pango gtk2 cairo gdk-pixbuf atk] ++
    (if swingSupport then [xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp xorg.libXt xorg.libXrender stdenv.cc.cc] else []);

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru.mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";

  passthru.jre = result; # FIXME: use multiple outputs or return actual JRE package

  passthru.home = result;

  passthru.architecture = architecture;

  meta = with stdenv.lib; {
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "armv7l-linux" "aarch64-linux" ]; # some inherit jre.meta.platforms
  };

}; in result
