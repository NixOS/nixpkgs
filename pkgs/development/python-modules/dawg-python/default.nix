{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "dawg-python";
  version = "0.7.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "DAWG-Python";
    hash = "sha256-Sl4yhuYmHMoC8gXP1VFqerEBkPowxRwo00WAj1leNCE=";
  };

  pythonImportsCheck = [ "dawg_python" ];

  meta = with lib; {
    description = "Pure Python reader for DAWGs created by dawgdic C++ library or DAWG Python extension";
    homepage = "https://github.com/pytries/DAWG-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
