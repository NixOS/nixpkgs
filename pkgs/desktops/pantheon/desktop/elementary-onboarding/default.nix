{ stdenv
, fetchFromGitHub
, pantheon
, fetchpatch
, pkgconfig
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, elementary-icon-theme
, elementary-gtk-theme
, gettext
, libhandy
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "1.1.0";

  repoName = "onboarding";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "17fw95qg7j0mvam90jrvr77hw2ipxb2lkw0xxql1lzwvdx1h0r2k";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-gtk-theme
    elementary-icon-theme
    glib
    granite
    gtk3
    libgee
    libhandy
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = https://github.com/elementary/onboarding;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
