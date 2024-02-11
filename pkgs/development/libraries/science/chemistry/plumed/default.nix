{ stdenv
, lib
, fetchFromGitHub
, blas
}:

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-yL+59f908IhbxGIylI1ydi1BPZwAapjK/vP4/h5gcHk=";
  };

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [] ++ lib.optional blas.isILP64 "--enable-ilp64";

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
