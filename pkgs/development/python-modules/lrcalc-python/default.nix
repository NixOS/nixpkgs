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
    sha256 = "e3a0509aeda487b412b391a52e817ca36b5c063a8305e09fd54d53259dd6aaa9";
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
