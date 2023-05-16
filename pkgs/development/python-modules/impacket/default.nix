{ lib
, buildPythonPackage
<<<<<<< HEAD
, charset-normalizer
, dsinternals
=======
, chardet
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, flask
, ldapdomaindump
, pyasn1
, pycryptodomex
, pyopenssl
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "impacket";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-7kA5tNKu3o9fZEeLxZ+qyGA2eWviTeqNwY8An7CQXko=";
  };

  propagatedBuildInputs = [
    charset-normalizer
    dsinternals
=======
    hash = "sha256-uOsCCiy7RxRmac/jHGS7Ln1kmdBJxJPWQYuXFvXHRYM=";
  };

  propagatedBuildInputs = [
    chardet
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    flask
    ldapdomaindump
    pyasn1
    pycryptodomex
    pyopenssl
    setuptools
    six
  ];

  # RecursionError: maximum recursion depth exceeded
  doCheck = false;

  pythonImportsCheck = [
    "impacket"
  ];

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
<<<<<<< HEAD
    changelog = "https://github.com/fortra/impacket/releases/tag/impacket_"
      + replaceStrings [ "." ] [ "_" ] version;
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ fab ];
=======
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
