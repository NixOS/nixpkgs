{
  lib,
  stdenv,
  fetchFromGitHub,
  coin-utils,
  coinmp,
  glpk,
  osi,
  gfortran,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symphony";
  version = "5.7.3";

  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "SYMPHONY";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-f97LICRykxhiZiSsSBE9IJBLL/ApWV+utvlHuUhx1PI=";
  };

  nativeBuildInputs = [
    gfortran
    libtool
    pkg-config
  ];

  buildInputs = [
    coin-utils
    coinmp
    glpk
    osi
  ];

  meta = {
    description = "Open-source solver, callable library, and development framework for mixed-integer linear programs (MILPs)";
    homepage = "https://www.coin-or.org/SYMPHONY/index.htm";
    changelog = "https://github.com/coin-or/SYMPHONY/blob/${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.linux;
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
})
