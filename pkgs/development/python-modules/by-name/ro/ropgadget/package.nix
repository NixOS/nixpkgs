{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  capstone,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ropgadget";
  version = "7.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    tag = "v${version}";
    hash = "sha256-vh5UYaIOQw+QJ+YT6dMi/YFCpQfY0w6ouuUWmJJMusA=";
  };

  build-system = [ setuptools ];

  dependencies = [ capstone ];

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
