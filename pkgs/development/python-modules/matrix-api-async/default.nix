{
  lib,
  buildPythonPackage,
  fetchPypi,
  matrix-client,
}:

buildPythonPackage rec {
  pname = "matrix_api_async";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g2H9j/q86RGy96Q7/c4bLX2tjZoP85ZAH1lREJlDvXU=";
  };

  propagatedBuildInputs = [ matrix-client ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "matrix_api_async" ];

  meta = with lib; {
    description = "Asyncio wrapper of matrix_client.api";
    license = licenses.mit;
    homepage = "https://github.com/Cadair/matrix_api_async";
    maintainers = with maintainers; [ globin ];
  };
}
