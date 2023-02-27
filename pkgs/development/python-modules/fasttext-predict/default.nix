{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pybind11
}:

buildPythonPackage rec {
  pname = "fasttext-predict";
  version = "0.9.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iSCt54tqBmNfrcntDFRXb550607Zr1mMCO2PC1ZbVQw=";
  };

  nativeBuildInputs = [
    pybind11
  ];

  # tests are removed from fork
  doCheck = false;

  pythonImportsCheck = [ "fasttext" ];

  meta = with lib; {
    description = "fasttext with wheels and no external dependency, but only the predict method (<1MB)";
    homepage = "https://github.com/searxng/fasttext-predict/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    # ImportError: dynamic module does not define module export function (PyInit_fasttext_pybind)
    broken = stdenv.isDarwin;
  };
}
