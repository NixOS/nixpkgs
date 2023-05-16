{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nose
, numpy
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "ecos";
<<<<<<< HEAD
  version = "2.0.11";
=======
  version = "2.0.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-jflmXR7fuGRSyI6NoQrHFvkKqF/D4iq47StNSCdLbqQ=";
    fetchSubmodules = true;
  };

=======
    rev = "v${version}";
    hash = "sha256-TPxrTyVZ1KXgPoDbZZqXT5+NEIEndg9qepujqFQwK+Q=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix for test_interface_bb.py tests
    (fetchpatch {
      name = "test_interface_bb_use_nparray.patch";
      url = "https://github.com/embotech/ecos-python/commit/4440dcb7ddbd92217bc83d8916b72b61537dffbf.patch";
      hash = "sha256-pcTPviK916jzCLllRhopbC9wDHv+aS6GmV/92sUwzHc=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    cd ./src
    nosetests test_interface.py test_interface_bb.py
  '';

  pythonImportsCheck = [
    "ecos"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Python interface for ECOS";
=======
    description = "Python package for ECOS: Embedded Cone Solver";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/embotech/ecos-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
