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

stdenv.mkDerivation rec {
  pname = "vala-lint";
  version = "0-unstable-2024-08-28";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = "vala-lint";
    rev = "4ed1443c35a8a84445fb59292d539358365d8263";
    sha256 = "sha256-NPadBrL2g5w95slwDpp7kNXBgLJ9na8Yd/J7zm28SSo=";
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

  postPatch = ''
    # https://github.com/vala-lang/vala-lint/issues/181
    substituteInPlace test/meson.build \
      --replace "test('auto-fix', auto_fix_test, env: test_envars)" ""
  '';

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
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.vala-lint";
  };
}
