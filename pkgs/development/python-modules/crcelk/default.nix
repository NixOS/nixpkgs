{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, lib
}:

buildPythonPackage rec {
  pname = "crcelk";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "zeroSteiner";
    repo = "crcelk";
    rev = "v${version}";
    hash = "sha256-eJt0qcG0ejTQJyjOSi6Au2jH801KOMnk7f6cLbd7ADw=";
  };

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "crcelk" ];

  meta = with lib; {
    homepage = "https://github.com/zeroSteiner/crcelk";
    description = "An updated fork of the CrcMoose module for recent versions of Python";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
  };
}
