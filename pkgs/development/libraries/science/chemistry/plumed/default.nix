{ stdenv
, lib
, fetchFromGitHub
, blas
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-ugYhJq8KFjT8rkAOX/yZ9IlEklXCwRxKH49REd2QN9E=";
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
