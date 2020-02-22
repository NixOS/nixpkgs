{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, psutil
}:

buildPythonPackage rec {
  pname = "helpdev";
  version = "0.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e61d24458b7506809670222ca656b139e67d46c530cd227a899780152d7b44e";
  };

  propagatedBuildInputs = [
    importlib-metadata
    psutil
  ];

  # No tests included in archive
  doCheck = false;

  meta = {
    description = "Extracts information about the Python environment easily";
    license = lib.licenses.mit;
  };

}