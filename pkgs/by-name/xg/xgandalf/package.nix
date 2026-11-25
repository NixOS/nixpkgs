{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  eigen,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "xgandalf";
  version = "1.0-unstable-2026-11-05";

  src = fetchFromGitLab {
    domain = "gitlab.desy.de";
    owner = "thomas.white";
    repo = "xgandalf";
    rev = "5bd4626c8dfdc150b2e161f568cb87eba4e6b407";
    hash = "sha256-lQxXDfxqaDMrL9CXyvVSHhm7MNncEojA8ir29gqwMN0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [ eigen ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "XGANDALF indexer";
    homepage = "https://gitlab.desy.de/thomas.white/xgandalf";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
}
