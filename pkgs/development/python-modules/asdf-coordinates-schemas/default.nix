{
  lib,
  asdf-standard,
  asdf,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asdf-coordinates-schemas";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf-coordinates-schemas";
    rev = "refs/tags/${version}";
    hash = "sha256-LuC0m25OqQwivK/Z3OfoCtdhBV87rk16XrkJxUxG07o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-standard
  ];

  # Circular dependency with asdf-astropy
  doCheck = false;

  pythonImportsCheck = [ "asdf_coordinates_schemas" ];

  meta = with lib; {
    description = "ASDF schemas for coordinates";
    homepage = "https://github.com/asdf-format/asdf-coordinates-schemas";
    changelog = "https://github.com/asdf-format/asdf-coordinates-schemas/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
