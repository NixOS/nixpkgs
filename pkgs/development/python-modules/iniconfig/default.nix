{
  lib,
  buildPythonPackage,
  replaceVars,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OrvS4ws2cz/uePnH9zCPLQBQ6I8Ah/0lwmRfY8dz4cc=";
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

  meta = with lib; {
    description = "Brain-dead simple parsing of ini files";
    homepage = "https://github.com/pytest-dev/iniconfig";
    license = licenses.mit;
    maintainers = [ ];
  };
}
