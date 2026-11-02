{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z/S5xQ2g3t9SrzSed0moCpBXpQMRmXkbkGw7s66HiWA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "iniconfig" ];

  # Requires pytest, which in turn requires this package - causes infinite
  # recursion. See also: https://github.com/NixOS/nixpkgs/issues/63168
  doCheck = false;

  meta = {
    description = "Brain-dead simple parsing of ini files";
    homepage = "https://github.com/pytest-dev/iniconfig";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
