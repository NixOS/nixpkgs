{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, libhandy
, elementary-icon-theme
, gettext
, wrapGAppsHook
, appstream
}:

stdenv.mkDerivation rec {
  pname = "elementary-feedback";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = version;
    sha256 = "02wydbpa5qaa4xmmh4m7rbj4djbrn2i44zjakj5i6mzwjlj6sv5n";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/feedback/pull/48
    (fetchpatch {
      url = "https://github.com/elementary/feedback/commit/080005153977a86d10099eff6a5b3e68f7b12847.patch";
      sha256 = "01710i90qsaqsrjs92ahwwj198bdrrif6mnw29l9har2rncfkfk2";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    elementary-icon-theme
    granite
    gtk3
    libgee
    libhandy
    glib
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = "https://github.com/elementary/feedback";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.feedback";
  };
}
