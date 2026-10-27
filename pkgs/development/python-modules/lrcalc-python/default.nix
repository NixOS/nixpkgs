{
  lib,
  fetchPypi,
  buildPythonPackage,
  cython,
  pkg-config,
  lrcalc,
}:

buildPythonPackage rec {
  pname = "lrcalc-python";
  version = "2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "lrcalc";
    hash = "sha256-46BQmu2kh7QSs5GlLoF8o2tcBjqDBeCf1U1TJZ3Wqqk=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [ lrcalc ];

  pythonImportsCheck = [ "lrcalc" ];

  meta = {
    description = "Littlewood-Richardson Calculator bindings";
    homepage = "https://sites.math.rutgers.edu/~asbuch/lrcalc/";
    teams = [ lib.teams.sage ];
    license = lib.licenses.gpl3;
  };
}
