{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
=======
, isPy27
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "httptools";
<<<<<<< HEAD
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n8bkCa04y9aLF3zVFY/EBCx5a4LKiNmex48HvtbGt5Y=";
  };

  # Tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [
    "httptools"
  ];
=======
  version = "0.5.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KVh0hhwXP5EBlgu6MyQpu3ftTc2M31zumSLrAOT2vAk=";
  };

  # tests are not included in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "httptools" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = "https://github.com/MagicStack/httptools";
<<<<<<< HEAD
    changelog = "https://github.com/MagicStack/httptools/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
