{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "xorg-autoconf";
  version = "1.20.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "macros";
    tag = "util-macros-${version}";
    hash = "sha256-COIWe7GMfbk76/QUIRsN5yvjd6MEarI0j0M+Xa0WoKQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "util-macros-";
      ignoredVersions = "1_0_2";
    };
  };

  meta = with lib; {
    description = "GNU autoconf macros shared across X.Org projects";
    homepage = "https://gitlab.freedesktop.org/xorg/util/macros";
    maintainers = with maintainers; [ raboof ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
