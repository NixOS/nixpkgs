{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pysecuritas";
  version = "0.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "W3DLZCXUH9y5NPipFEu6URmKN+oVXMgeDF1rfKtxRng=";
  };

  propagatedBuildInputs = [
    xmltodict
    requests
  ];

  # Project doesn't ship tests with PyPI releases
  # https://github.com/Cebeerre/pysecuritas/issues/13
  doCheck = false;

  pythonImportsCheck = [ "pysecuritas" ];

  meta = with lib; {
    description = "Python client to access Securitas Direct Mobile API";
    mainProgram = "pysecuritas";
    homepage = "https://github.com/Cebeerre/pysecuritas";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
