{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, gettext, meson, gsound, librsvg, itstool, vala
, python3, ninja, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "four-in-a-row";
  version = "3.36.3";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1qc6s0v8gnzw3wfbfaaindb031cc8akdjdn2sjqqfxhbpx6mhzmr";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook gettext meson itstool vala
    ninja python3 desktop-file-utils
  ];
  buildInputs = [ gtk3 gsound librsvg gnome3.adwaita-icon-theme ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "four-in-a-row";
      attrPath = "gnome3.four-in-a-row";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Four-in-a-row";
    description = "Make lines of the same color to win";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
