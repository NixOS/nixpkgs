{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ropgadget";
  version = "7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    rev = "refs/tags/v${version}";
    hash = "sha256-eVRQQ8VmjT8wTpiTK2Emr1tEpSwFJPbMc1fa2Zh3mT0=";
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
