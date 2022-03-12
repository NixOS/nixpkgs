{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ropgadget";
  version = "6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    rev = "v${version}";
    hash = "sha256-zOTbncsOvmLQMZGpcRLviSZP/d1cQTQHXCLUKyEgVBk=";
  };

  propagatedBuildInputs = [
    capstone
  ];

  # Test suite is working with binaries
  doCheck = false;

  pythonImportsCheck = [
    "ropgadget"
  ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
