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
    sha256 = "0xdx8fci0lar3x09dwqgka6ssz9d3g7gsfx4yyr13sdwza7zsqc3";
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
