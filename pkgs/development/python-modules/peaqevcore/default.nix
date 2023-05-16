{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peaqevcore";
<<<<<<< HEAD
  version = "19.3.2";
=======
  version = "15.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-hVI3syst8F5BNrHcu21OxszPMWuv0wY65yFdfoXLMWM=";
  };

  postPatch = ''
    sed -i "/extras_require/d" setup.py
=======
    hash = "sha256-nbDySNyHsy/5RaN7L/lbMunfXp+Ohyq0sZWPXirFbqs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest" ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Tests are not shipped and source is not tagged
  # https://github.com/elden1337/peaqev-core/issues/4
  doCheck = false;

  pythonImportsCheck = [
    "peaqevcore"
  ];

  meta = with lib; {
    description = "Library for interacting with Peaqev car charging";
    homepage = "https://github.com/elden1337/peaqev-core";
<<<<<<< HEAD
    changelog = "https://github.com/elden1337/peaqev-core/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
