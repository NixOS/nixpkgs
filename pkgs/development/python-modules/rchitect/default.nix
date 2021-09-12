{ lib
, buildPythonPackage
, fetchPypi
, cffi
, pytest-runner
, six
}:

buildPythonPackage rec {
  pname = "rchitect";
  version = "0.3.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ghA7Go1E3TcGqgvY6CVP5UKN1S1GLwy5hmxYPrcoasM=";
  };

  buildInputs = [
    pytest-runner
  ];

  # Tests not included in PyPI release
  doCheck = false;

  propagatedBuildInputs = [
    cffi
    six
  ];

  pythonImportsCheck = [ "rchitect" ];

  meta = with lib; {
    description = "Interoperate R with Python";
    homepage = "https://github.com/randy3k/rchitect";
    license = licenses.mit;
    maintainers = with maintainers; [ jdreaver ];
  };
}
