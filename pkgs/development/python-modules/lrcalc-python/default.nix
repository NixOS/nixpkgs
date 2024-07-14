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

  meta = with lib; {
    description = "Littlewood-Richardson Calculator bindings";
    homepage = "https://sites.math.rutgers.edu/~asbuch/lrcalc/";
    maintainers = teams.sage.members;
    license = licenses.gpl3;
  };
}
