{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdfrw,
}:

buildPythonPackage rec {
  pname = "pagelabels";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qt6JPKqEtrvQWbw/SEl9zEg/H4J3ob6fW8bI7f8sWh0=";
  };

  buildInputs = [ pdfrw ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = with lib; {
    description = "Python library to manipulate PDF page labels";
    homepage = "https://github.com/lovasoa/pagelabels-py";
    maintainers = with maintainers; [ teto ];
    license = licenses.gpl3;
  };
}
