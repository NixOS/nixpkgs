{ lib
, buildPythonPackage
, fetchPypi
, fastprogress
, fastcore
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastdownload";
<<<<<<< HEAD
  version = "0.0.7";
=======
  version = "0.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-IFB+246JQGofvXd15uKj2BpN1jPdUGsOnPDhYT6DHWo=";
=======
    sha256 = "sha256-1ayb0zx8rFKDgqlq/tVVLqDkh47T5jofHt53r8bWr30=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ fastprogress fastcore ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastdownload" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/fastdownload";
    description = "Easily download, verify, and extract archives";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
