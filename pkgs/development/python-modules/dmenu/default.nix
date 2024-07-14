{
  buildPythonPackage,
  lib,
  fetchPypi,
  dmenu,
}:

buildPythonPackage rec {
  pname = "dmenu-python";
  version = "0.2.1";

  src = fetchPypi {
    inherit version;
    pname = "dmenu";
    hash = "sha256-lZMBPU+kJ2PELBb9GS5ub1ggmZ1kLn1WXJSqyAB2Yhs=";
  };

  propagatedBuildInputs = [ dmenu ];

  # No tests existing
  doCheck = false;

  meta = {
    description = "Python wrapper for dmenu";
    homepage = "https://dmenu.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
