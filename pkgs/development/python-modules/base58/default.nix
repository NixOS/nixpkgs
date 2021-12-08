{ lib
, buildPythonPackage
, fetchFromGitHub
, pyhamcrest
, pytest-benchmark
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "base58";
  version = "2.1.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "keis";
     repo = "base58";
     rev = "v2.1.1";
     sha256 = "0mi9m7wmp93qzv0n92r1qi0yskj2vr0ffh0wpl0r4x6krfvyy7xm";
  };

  checkInputs = [
    pyhamcrest
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "base58" ];

  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
