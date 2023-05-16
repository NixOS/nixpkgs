{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchPypi
, pyopenssl
, pythonOlder
, requests
, setuptools
=======
, fetchFromGitHub
, pyopenssl
, pythonOlder
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "netio";
<<<<<<< HEAD
  version = "1.0.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname ="Netio";
    inherit version;
    hash = "sha256-+fGs7ZwvspAW4GlO5Hx+gNb+7Mhl9HC4pijHyk+8PYs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    rev = "v${version}";
    hash = "sha256-07GzT9j27KmrTQ7naIdlIz7HB9knHpjH4mQhlwUKucU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.py \
      --replace "import py2exe" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "Netio"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with NETIO devices";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
