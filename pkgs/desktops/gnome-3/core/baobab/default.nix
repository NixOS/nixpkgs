{ stdenv, lib, gettext, fetchurl, vala, desktop-file-utils
, meson , ninja , pkgconfig , gtk3 , glib , libxml2
, wrapGAppsHook , itstool , gnome3
, gnused
}:
let
  pname = "baobab";
  version = "3.34.0";
in stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  srcs = [ (fetchurl {
      url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
      sha256 = "01w6m5ylyqs4wslpjn1hg6n6ynwh3rghksak0qs8r9m6dm3dkss6";
    })
    ./baobab-icons.tar.gz
  ];

  sourceRoot = "${name}";

  nativeBuildInputs = [ meson ninja pkgconfig vala gettext itstool libxml2 desktop-file-utils wrapGAppsHook ];
  buildInputs = [ gnused gtk3 glib gnome3.adwaita-icon-theme ];

  doCheck = true;

  postPatch = ''
    cp -r ../icons .
  '';

  # Deletes traductions for Icon Entry in .desktop
  # And deletes the NotShowIn=KDE thing.
  postBuild = ''
    sed -i "/^Icon\[.*\].*$/d" data/org.gnome.baobab.desktop
    sed -i "/^NotShowIn=KDE;$/d" data/org.gnome.baobab.desktop
  '';

  postInstall = ''
    install -Dm 644 ../icons/16-app-icon.png $out/share/icons/hicolor/16x16/apps/org.gnome.baobab.png
    install -Dm 644 ../icons/22-app-icon.png $out/share/icons/hicolor/22x22/apps/org.gnome.baobab.png
    install -Dm 644 ../icons/32-app-icon.png $out/share/icons/hicolor/32x32/apps/org.gnome.baobab.png
    install -Dm 644 ../icons/48-app-icon.png $out/share/icons/hicolor/48x48/apps/org.gnome.baobab.png
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    homepage = "https://wiki.gnome.org/Apps/DiskUsageAnalyzer";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
