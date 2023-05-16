{ stdenv
, lib
, fetchFromGitHub
, blas
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
<<<<<<< HEAD
  version = "2.9.0";
=======
  version = "2.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yL+59f908IhbxGIylI1ydi1BPZwAapjK/vP4/h5gcHk=";
=======
    hash = "sha256-ugYhJq8KFjT8rkAOX/yZ9IlEklXCwRxKH49REd2QN9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
