{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7UanIYo2PvGjSPrBTJ/vlbCspdqndEOJ1whD/MCWGzE=";
  };

  # no tests in PyPI
  doCheck = false;

  meta = with lib; {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
