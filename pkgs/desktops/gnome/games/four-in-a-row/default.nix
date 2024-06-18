{ lib, stdenv, fetchurl, pkg-config, gnome, gtk3, wrapGAppsHook3
, gettext, meson, gsound, librsvg, itstool, vala
, python3, ninja, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "four-in-a-row";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "10ji60bdfdzb6wk5dkwjc3yww7hqi3yjcx1k1z7x2521h2dpdli1";
  };

  nativeBuildInputs = [
    pkg-config wrapGAppsHook3 gettext meson itstool vala
    ninja python3 desktop-file-utils
  ];
  buildInputs = [ gtk3 gsound librsvg gnome.adwaita-icon-theme ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "four-in-a-row";
      attrPath = "gnome.four-in-a-row";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/four-in-a-row";
    description = "Make lines of the same color to win";
    mainProgram = "four-in-a-row";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
