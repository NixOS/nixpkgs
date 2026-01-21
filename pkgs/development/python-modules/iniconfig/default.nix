{
  lib,
  buildPythonPackage,
  replaceVars,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x2MVx32waGUNScW1YxR3SngE3xb+5EAsHxnW0V2MRzA=";
  };

  build-system = [ hatchling ];

  patches = [
    # Cannot use hatch-vcs, due to an infinite recursion
    (replaceVars ./version.patch {
      inherit version;
    })
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
