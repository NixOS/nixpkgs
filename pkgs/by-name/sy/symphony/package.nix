{
  lib,
  stdenv,
  fetchFromGitHub,
  coin-utils,
  coinmp,
  gfortran,
  libtool,
  glpk,
  osi,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "symphony";
  version = "5.7.3";

  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "SYMPHONY";
    rev = "releases/${version}";
    hash = "sha256-f97LICRykxhiZiSsSBE9IJBLL/ApWV+utvlHuUhx1PI=";
  };

  nativeBuildInputs = [
    libtool
    pkg-config
    glpk
    gfortran
    coinmp
    osi
    coin-utils
  ];

  meta = {
    description = "Open-source solver, callable library, and development framework for mixed-integer linear programs (MILPs)";
    homepage = "https://www.coin-or.org/SYMPHONY/index.htm";
    changelog = "https://github.com/coin-or/SYMPHONY/blob/${version}/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
