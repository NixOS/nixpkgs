{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "donut-shellcode";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TheWover";
    repo = "donut";
    rev = "v${version}";
    hash = "sha256-gKa7ngq2+r4EYRdwH9AWnJodJjCdppzKch4Ve/4ZPhk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "donut" ];

  meta = {
    description = "Module to generate x86, x64, or AMD64+x86 position-independent shellcode";
    homepage = "https://github.com/TheWover/donut";
    changelog = "https://github.com/TheWover/donut/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
