{ buildPythonPackage
, lib
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, networkx
, numpy
, scipy
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geometric";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "leeping";
    repo = "geomeTRIC";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-3d4z1n8+e0HgdeKLNSsHLb3XHOk09uy+gP9AwNvNITE=";
  };

  patches = [ (fetchpatch {
    name = "ase-is-optional";
    url = "https://github.com/leeping/geomeTRIC/commit/aff6e4411980ac9cbe112a050c3a34ba7e305a43.patch";
    hash = "sha256-JGGPX+JwkQ8Imgmyx+ReRTV+k6mxHYgm+Nd8WUjbFEg=";
  }) ];
=======
    hash = "sha256-y8dh4vZ/d1KL1EpDrle8CH/KIDMCKKZdAyJVgUFjx/o=";
  };

  patches = [
    ./ase-is-optional.patch
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    six
  ];

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Geometry optimization code for molecular structures";
    homepage = "https://github.com/leeping/geomeTRIC";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.markuskowa ];
  };
}

