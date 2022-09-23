{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, librsvg
, libgnome-games-support
, gettext
, itstool
, libxml2
, python3
, vala
}:

stdenv.mkDerivation rec {
  pname = "five-or-more";
  version = "3.32.3";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "LRDXLu/esyS0R9YyrwwySW4l/BWjwB230vAMm1HQnvQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    python3
    wrapGAppsHook
    vala
  ];

  buildInputs = [
    gtk3
    librsvg
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "five-or-more";
      attrPath = "gnome.five-or-more";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Five_or_more";
    description = "Remove colored balls from the board by forming lines";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
