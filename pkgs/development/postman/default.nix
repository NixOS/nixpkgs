{ stdenv, alsaLib, atk, buildEnv, bzip2, cairo, cups, curl, dbus_libs
, expat, fetchurl, flac, fontconfig, freetype, gcc-unwrapped, gconf
, gdk_pixbuf, glib, gtk2, harfbuzz, icu, libcap, liberation_ttf, libexif
, libnotify, libopus, libpng, makeWrapper, mesa_noglu, nspr, nss, nssTools
, pango, pciutils, snappy, speechd, systemd, udev, utillinux, wget
, xdg_utils, xlibs, xorg, zlib }:
with stdenv.lib;
let
  version = "5.5.0";

  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  deps = [
    glib fontconfig freetype pango cairo xorg.libX11 xorg.libXi atk gconf nss nspr
    xorg.libXcursor xorg.libXext xorg.libXfixes xorg.libXrender xorg.libXScrnSaver xorg.libXcomposite xorg.libxcb
    alsaLib xorg.libXdamage xorg.libXtst xorg.libXrandr expat cups
    dbus_libs gdk_pixbuf gcc-unwrapped.lib
    systemd
    libexif
    liberation_ttf curl utillinux xdg_utils wget
    flac harfbuzz icu libpng opusWithCustomModes snappy speechd
    bzip2 libcap
    gtk2
  ];
in
stdenv.mkDerivation {
  name = "postman-${version}";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha256 = "1bz9zaz5wi6qgacppc591p318yz3hm7sm8ks83pngkbq4vjnh3fn";
  };

  dontPatchELF = true;

  unpackPhase = ''
    mkdir -p $out
    cd $out
    tar xfz $src
  '';

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  installPhase = ''
    patchelf --set-rpath $rpath \
             --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             $out/Postman/Postman

    mkdir -p $out/bin
    cat > $out/bin/postman << EOF
    #!/usr/bin/env sh
    cd $out/Postman
    export LD_LIBRARY_PATH=$out/Postman
    exec ./Postman
    EOF
    chmod +x $out/bin/postman
  '';

  meta = with stdenv.lib; {
    description = "GUI for API development";
    homepage = https://www.getpostman.com;
    license = licenses.postman;
    maintainers = [ maintainers.manveru ];
    platforms = ["x86_64-linux"];
    longDescription = ''
      A powerful GUI platform to make your API development faster & easier, from
      building API requests through testing, documentation and sharing.
    '';
  };
}
