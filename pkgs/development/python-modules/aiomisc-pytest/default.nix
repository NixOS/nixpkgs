{ lib
, aiomisc
, buildPythonPackage
, fetchPypi
, poetry-core
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiomisc-pytest";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "aiomisc_pytest";
    inherit version;
    hash = "sha256-LDeMQbB4wFdgJ95r9/vFN6fmkoXSPq9NRXONXQ3lbdM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiomisc
  ];

  pythonImportsCheck = [
    "aiomisc_pytest"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Pytest integration for aiomisc";
    homepage = "https://github.com/aiokitchen/aiomisc";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
