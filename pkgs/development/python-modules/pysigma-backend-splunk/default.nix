{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pysigma-pipeline-sysmon
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-backend-splunk";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    rev = "v${version}";
    hash = "sha256-wcAqXFou20V2ZPOXCsF1Nky008q2xkfuI0RbTsatC6k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  checkInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.backends.splunk"
  ];

  meta = with lib; {
    description = "Library to support Splunk for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-splunk";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
