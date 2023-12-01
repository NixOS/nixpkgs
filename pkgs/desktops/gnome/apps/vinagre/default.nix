{ lib, stdenv, fetchurl, fetchpatch, pkg-config, gtk3, gnome, vte, libxml2, gtk-vnc, intltool
, libsecret, itstool, wrapGAppsHook, librsvg }:

stdenv.mkDerivation rec {
  pname = "vinagre";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "cd1cdbacca25c8d1debf847455155ee798c3e67a20903df8b228d4ece5505e82";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchain support:
    #   https://gitlab.gnome.org/GNOME/vinagre/-/merge_requests/8
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitlab.gnome.org/GNOME/vinagre/-/commit/c51662cf4338516773d64776c3c92796917ff2bd.diff";
      sha256 = "0zn8cd93hjdz6rw2d7gfl1ghzkc9h0x40k9l0jx3n5qfwdq4sir8";
    })
  ];

  nativeBuildInputs = [ pkg-config intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 vte libxml2 gtk-vnc libsecret gnome.adwaita-icon-theme librsvg
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "vinagre";
      attrPath = "gnome.vinagre";
    };
  };

  meta = with lib; {
    description = "Remote desktop viewer for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Vinagre";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
