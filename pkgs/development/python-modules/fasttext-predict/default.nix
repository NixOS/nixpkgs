{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pybind11
}:

buildPythonPackage rec {
  pname = "fasttext-predict";
  version = "0.9.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rMbf09pCHvVYI9g/aq74+PcsuU2LezpmDz4b/w9vRyc=";
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
