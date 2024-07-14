{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
  future,
}:

buildPythonPackage rec {
  pname = "ecpy";
  version = "1.2.5";

  src = fetchPypi {
    pname = "ECPy";
    inherit version;
    hash = "sha256-ljXP+5tuz3/X9yrqFmWCmsdKHScgBtAFfUWmIariAig=";
  };

  prePatch = ''
    sed -i "s|reqs.append('future')|pass|" setup.py
  '';

  propagatedBuildInputs = lib.optional (!isPy3k) future;

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "ecpy" ];

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = "https://github.com/ubinity/ECPy";
    license = licenses.asl20;
  };
}
