{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sanix";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tomaszsluszniak";
    repo = "sanix_py";
    rev = "refs/tags/v${version}";
    hash = "sha256-D2w3hmL8ym63liWOYdZS4ry3lJ0utbbYGagWoOTT1TQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sanix" ];

  meta = with lib; {
    description = "Module to get measurements data from Sanix devices";
    homepage = "https://github.com/tomaszsluszniak/sanix_py";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
