{ productVersion
, patchVersion
, buildVersion
, sha256
, jceName
, releaseToken
, sha256JCE
}:

{ swingSupport ? true
, stdenv
, fetchurl
, makeWrapper
, unzip
, file
, xorg ? null
, installjdk ? true
, pluginSupport ? true
, installjce ? false
, config
, licenseAccepted ? config.oraclejdk.accept_license or false
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
, gdk_pixbuf
, setJavaClassPath
}:

assert swingSupport -> xorg != null;

if !licenseAccepted then throw ''
    You must accept the Oracle Binary Code License Agreement for Java SE at
    https://www.oracle.com/technetwork/java/javase/terms/license/index.html
    by setting nixpkgs config option 'oraclejdk.accept_license = true;'
  ''
else assert licenseAccepted;

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture = {
    i686-linux    = "i386";
    x86_64-linux  = "amd64";
    armv7l-linux  = "arm";
    aarch64-linux = "aarch64";
  }.${stdenv.hostPlatform.system};

  jce =
    if installjce then
      fetchurl {
        url = "http://download.oracle.com/otn-pub/java/jce/${productVersion}/${jceName}";
        sha256 = sha256JCE;
        curlOpts = "-b oraclelicense=a";
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

assert sha256 ? ${stdenv.hostPlatform.system};

let result = stdenv.mkDerivation rec {
  name =
    if installjdk then "oraclejdk-${productVersion}u${patchVersion}" else "oraclejre-${productVersion}u${patchVersion}";

  src = let
    platformName = {
      i686-linux    = "linux-i586";
      x86_64-linux  = "linux-x64";
      armv7l-linux  = "linux-arm32-vfp-hflt";
      aarch64-linux = "linux-arm64-vfp-hflt";
    }.${stdenv.hostPlatform.system};
    javadlPlatformName = "linux-i586";
  in fetchurl {
   url = "http://javadl.oracle.com/webapps/download/GetFile/1.${productVersion}.0_${patchVersion}-b${buildVersion}/${releaseToken}/${javadlPlatformName}/jdk-${productVersion}u${patchVersion}-${platformName}.tar.gz";
   curlOpts = "-b oraclelicense=a";
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
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
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
    [stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt libGL xorg.libXxf86vm alsaLib fontconfig freetype pango gtk2 cairo gdk_pixbuf atk] ++
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

}; in stdenv.lib.trivial.warn "Public updates for Oracle Java SE 8 released after January 2019 will not be available for business, commercial or production use without a commercial license. See https://java.com/en/download/release_notice.jsp for more information." result
