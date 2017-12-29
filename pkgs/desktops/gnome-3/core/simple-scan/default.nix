{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, itstool, wrapGAppsHook
, cairo, gdk_pixbuf, colord, glib, gtk, gusb, packagekit, libwebp
, libxml2, sane-backends, vala, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ cairo gdk_pixbuf colord glib gnome3.defaultIconTheme gusb
                gtk libwebp packagekit sane-backends vala ];
  nativeBuildInputs = [ meson ninja gettext itstool pkgconfig wrapGAppsHook libxml2 ];

  postPatch = ''
    patchShebangs data/meson_compile_gschema.py

    sed -i -e 's#Icon=scanner#Icon=simple-scan#g' ./data/simple-scan.desktop.in
  '';

  postInstall = ''
    mkdir -p $out/share/icons
    mv $out/share/simple-scan/icons/* $out/share/icons/
    (
    cd ${gnome3.defaultIconTheme}/share/icons/Adwaita
    for f in `find . | grep 'scanner\.'`
    do
      local outFile="`echo "$out/share/icons/hicolor/$f" | sed \
        -e 's#/devices/#/apps/#g' \
        -e 's#scanner\.#simple-scan\.#g'`"
      mkdir -p "`realpath -m "$outFile/.."`"
      cp "$f" "$outFile"
    done
    )
  '';

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = "meson test";

  meta = with stdenv.lib; {
    description = "Simple scanning utility";
    longDescription = ''
      A really easy way to scan both documents and photos. You can crop out the
      bad parts of a photo and rotate it if it is the wrong way round. You can
      print your scans, export them to pdf, or save them in a range of image
      formats. Basically a frontend for SANE - which is the same backend as
      XSANE uses. This means that all existing scanners will work and the
      interface is well tested.
    '';
    homepage = https://launchpad.net/simple-scan;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
