{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  json-glib,
  meson,
  ninja,
  pantheon,
  pkg-config,
  vala,
  gettext,
  wrapGAppsHook3,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "vala-lint";
  version = "0-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "a1d1a7bc0f740920e592fd788a836c402fd9825c";
    sha256 = "sha256-63T+wLdnGtVBxKkkkj7gJx0ebApam922Z+cmk2R7Ys0=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    json-glib
  ];

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/vala-lang/vala-lint.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/vala-lang/vala-lint";
    description = "Check Vala code files for code-style errors";
    longDescription = ''
      Small command line tool and library for checking Vala code files for code-style errors.
      Based on the elementary Code-Style guidelines.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.vala-lint";
  };
}
