{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  expat,
}:

buildPythonPackage rec {
  pname = "asterix_decoder";
  version = "0.7.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BN/jQVZO5xlx9wfCVUirkDoSuHZY3WJDHkHQm1SrVwM=";
  };

  build-system = [ setuptools ];

  buildInputs = [ expat ];

  meta = with lib; {
    description = "ASTERIX decoder in Python";
    license = licenses.gpl2;
    homepage = "https://github.com/CroatiaControlLtd/asterix";
    maintainers = with maintainers; [ gthm ];
  };
}
