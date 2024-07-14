{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyfnip";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-arwIsqsj+d6sMatBJc1eEr95Nvg8Y9lfpOtBPcHKomA=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyfnip" ];

  meta = with lib; {
    description = "Python client to get fido account data";
    homepage = "https://github.com/juhaniemi/pyfnip";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
