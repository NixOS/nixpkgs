{
  stdenv,
  lib,
  fetchFromGitHub,
  blas,
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-68/ajM87ApEXUs4xPIq7Vfmzl7Ms4ck6jnjlIv7woMs=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
