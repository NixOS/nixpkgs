{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyvex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.110";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "ailment";
    rev = "refs/tags/v${version}";
    hash = "sha256-hW76M2Vzpyx2p0VHNKRKxH2Ec5aF0WJ5y7zkbteS9YE=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyvex ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [ "ailment" ];

  meta = with lib; {
    description = "Angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
