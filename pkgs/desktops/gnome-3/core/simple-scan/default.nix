{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, itstool, wrapGAppsHook
, cairo, gdk_pixbuf, colord, glib, gtk, gusb, packagekit, libwebp
, libxml2, sane-backends, vala, gnome3, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "simple-scan-${version}";
  version = "3.26.3";

  src = fetchurl {
    url = "mirror://gnome/sources/simple-scan/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0galkcc76j0p016fvwn16llh0kh4ykvjy4v7kc6qqnlp38g174n3";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "simple-scan"; };
  };

  buildInputs = [ cairo gdk_pixbuf colord glib gnome3.defaultIconTheme gusb
                gtk libwebp packagekit sane-backends vala ];
  nativeBuildInputs = [
    meson ninja gettext itstool pkgconfig wrapGAppsHook libxml2
    # For setup hook
    gobjectIntrospection
  ];

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
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
