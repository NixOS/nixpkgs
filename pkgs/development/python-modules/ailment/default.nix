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
  version = "9.2.100";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "ailment";
    rev = "refs/tags/v${version}";
    hash = "sha256-qjEQ+pk/5Zp1HRrT/MlpmExB86JCF4kW3UHn3/anND4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyvex ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [ "ailment" ];

  meta = with lib; {
    description = "The angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
