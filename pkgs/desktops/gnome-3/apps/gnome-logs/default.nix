{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, gnome3, glib, gtk3, wrapGAppsHook, desktop-file-utils
, gettext, itstool, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_43, systemd, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-logs-${version}";
  version = "3.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1bpg8172f16sgbhsn2sis3xh2ylrv8vj7j12xdxkmsmfh2k2bqfy";
  };

  patches = [
    # Fix post_install script
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-logs/commit/2f498464ac539fdf98199294bfb9205436b9c323.patch;
      sha256 = "1v6d8zgd31waliwlvk5xlfjap5h84bpqb1az0wdjm4c2a53iiwlp";
    })
    # Fix a typo in manpage generation
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-logs/commit/02b782fcd64d4773e2dadbdb9ea74bf3923003b3.patch;
      sha256 = "1a8zcp62shspw45s0dvi2iv83qppz4hcw31id6zlwq0dp94vvb46";
    })
  ];

  mesonFlags = [
    "-Dtests=true"
    "-Dman=true"
  ];

  nativeBuildInputs = [
    (python3.withPackages (pkgs: with pkgs; [ dogtail ]))
    meson ninja pkgconfig wrapGAppsHook gettext itstool desktop-file-utils
    libxml2 libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib gtk3 systemd gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome3.gnome-logs";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Logs;
    description = "A log viewer for the systemd journal";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
