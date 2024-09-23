{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ropgadget";
  version = "7.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    rev = "refs/tags/v${version}";
    hash = "sha256-6m8opcTM4vrK+VCPXxNhZttUq6YmS8swLUDhjyfinWE=";
  };

  propagatedBuildInputs = [ capstone ];

  # Test suite is working with binaries
  doCheck = false;

  pythonImportsCheck = [ "ropgadget" ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    mainProgram = "ROPgadget";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
