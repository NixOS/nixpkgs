{ stdenv, lib, fetchurl, unzip, makeWrapper, setJavaClassPath
, zulu, glib, libxml2, libav_0_8, ffmpeg, libxslt, libGL, alsaLib
, fontconfig, freetype, gnome2, cairo, gdk-pixbuf, atk, xorg
, swingSupport ? true }:

let
  version = "8.28.0.1";
  openjdk = "8.0.163";

  sha256_linux = "1z8s3a948nvv92wybnhkyr27ipibcy45k0zv5h5gp37ynd91df45";
  sha256_darwin = "0i0prjijsgg0yyycplpp9rlfl428126rqz7bb31pchrhi6jhk699";

  platform = if stdenv.isDarwin then "macosx" else "linux";
  hash = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  extension = if stdenv.isDarwin then "zip" else "tar.gz";

  libraries = [
    stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt libGL
    xorg.libXxf86vm alsaLib fontconfig freetype gnome2.pango
    gnome2.gtk cairo gdk-pixbuf atk
  ] ++ (lib.optionals swingSupport (with xorg; [
    xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp
    xorg.libXt xorg.libXrender stdenv.cc.cc
  ]));

in stdenv.mkDerivation {
  inherit version openjdk platform hash extension;

  pname = "zulu";

  src = fetchurl {
    url = "https://cdn.azul.com/zulu/bin/zulu${version}-jdk${openjdk}-${platform}_x64.${extension}";
    sha256 = hash;
  };

  buildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin unzip;

  installPhase = ''
    mkdir -p $out
    cp -r ./* "$out/"

    jrePath="$out/jre"

    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/jli
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/server
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/xawt
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64

    # set all the dynamic linkers
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru = {
    home = zulu;
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
