{ lib
, bitlist
, buildPythonPackage
, fe25519
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "ge25519";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-VKDPiSdufWwrNcZSRTByFU4YGoJrm48TDm1nt4VyclA=";
=======
    hash = "sha256-oOvrfRSpvwfCcmpV7FOxcBOW8Ex89d2+otjORrzX4o0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    fe25519
    parts
    bitlist
    fountains
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=ge25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "ge25519"
  ];

  meta = with lib; {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
