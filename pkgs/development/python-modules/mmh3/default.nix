{ lib
, fetchPypi
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mmh3";
<<<<<<< HEAD
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rYvmldxORKeWMXSLpVYtgD8KxC02prl6U6yoSnCAk4U=";
  };

  pythonImportsCheck = [
    "mmh3"
  ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://github.com/hajimes/mmh3";
    changelog = "https://github.com/hajimes/mmh3/blob/v${version}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = with maintainers; [ ];
=======
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mw8rKrSpFTM8nRCJVy4pCgIeu1uQC7f3EU3MwDmV1zI=";
  };

  pythonImportsCheck = [ "mmh3" ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://pypi.org/project/mmh3/";
    license = licenses.cc0;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
