{ stdenv, lib, fetchurl, unzip, makeWrapper, setJavaClassPath
, zulu, glib, libxml2, libav_0_8, ffmpeg, libxslt, mesa_noglu, alsaLib
, fontconfig, freetype, gnome2, cairo, gdk_pixbuf, atk, xorg, zlib
, swingSupport ? true }:

let
  version = "9.0.0.15";
  openjdk = "9.0.0";

  sha256_linux = "0s9vr135yhdnxqds4hfafyrlh33j6g78v6l1v0ap2y6yqgabh9qi";
  sha256_darwin = "104w1msrwijf8dv3n65hjinp7i47z6ygzjipdzqriqam2zljxn4b";

  platform = if stdenv.isDarwin then "macosx" else "linux";
  hash = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  extension = if stdenv.isDarwin then "zip" else "tar.gz";

  libraries = [
    stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt mesa_noglu
    xorg.libXxf86vm alsaLib fontconfig freetype gnome2.pango
    gnome2.gtk cairo gdk_pixbuf atk zlib
  ] ++ (lib.optionals swingSupport (with xorg; [
    xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp
    xorg.libXt xorg.libXrender stdenv.cc.cc
  ]));

in stdenv.mkDerivation rec {
  inherit version openjdk platform hash extension;

  name = "zulu-${version}";

  src = fetchurl {
    url = "https://cdn.azul.com/zulu/bin/zulu${version}-jdk${openjdk}-${platform}_x64.${extension}";
    sha256 = hash;
  };

  buildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin unzip;

  installPhase = ''
    mkdir -p $out
    cp -r ./* "$out/"

    rpath=$rpath''${rpath:+:}$out/lib/jli
    rpath=$rpath''${rpath:+:}$out/lib/server
    rpath=$rpath''${rpath:+:}$out/lib

    # set all the dynamic linkers
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-native-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru = {
    home = "${zulu}";
  };

  meta = with stdenv.lib; {
    homepage = https://www.azul.com/products/zulu/;
    license = licenses.gpl2;
    description = "Certified builds of OpenJDK";
    longDescription = ''
      Certified builds of OpenJDK that can be deployed across multiple
      operating systems, containers, hypervisors and Cloud platforms.
    '';
    maintainers = with maintainers; [ nequissimus fpletz ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
