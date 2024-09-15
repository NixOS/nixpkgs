{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gtk3,
  gnome,
  adwaita-icon-theme,
  vte,
  libxml2,
  gtk-vnc,
  intltool,
  libsecret,
  itstool,
  wrapGAppsHook3,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "vinagre";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${lib.versions.majorMinor version}/vinagre-${version}.tar.xz";
    hash = "sha256-zRzbrMolyNHev4R0VRVe55jD5nogkD34sijU7OVQXoI=";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchain support:
    #   https://gitlab.gnome.org/Archive/vinagre/-/merge_requests/8
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitlab.gnome.org/Archive/vinagre/-/commit/c51662cf4338516773d64776c3c92796917ff2bd.diff";
      hash = "sha256-KEdNcOMOFzu6BDRNQDqAic0PX6DunSZ4Nr9JOFJjyH4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    itstool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    vte
    libxml2
    gtk-vnc
    libsecret
    adwaita-icon-theme
    librsvg
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  passthru = {
    updateScript = gnome.updateScript { packageName = "vinagre"; };
  };

  meta = with lib; {
    description = "Remote desktop viewer for GNOME";
    mainProgram = "vinagre";
    homepage = "https://gitlab.gnome.org/Archive/vinagre";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
