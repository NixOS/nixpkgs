{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  requests,
  setuptools,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "pyfnip";
  version = "0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-arwIsqsj+d6sMatBJc1eEr95Nvg8Y9lfpOtBPcHKomA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyfnip" ];

  meta = with lib; {
    description = "Python client to get fido account data";
    homepage = "https://github.com/juhaniemi/pyfnip";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
