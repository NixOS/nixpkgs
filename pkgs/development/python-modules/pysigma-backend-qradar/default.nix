{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pysigma-pipeline-sysmon
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pysigma-backend-qradar";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nNipsx-Sec";
    repo = "pySigma-backend-qradar";
    rev = "refs/tags/v${version}";
    hash = "sha256-kd/KWO3xxIHPgXqvcOrSvdozLG34+DwZedfSVoZ+dDA=";
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pysigma = "^0.7.2"' 'pysigma = "*"'
  '';

  pythonImportsCheck = [
    "sigma.backends.qradar"
  ];

  meta = with lib; {
    description = "Library to support Qradar for pySigma";
    homepage = "https://github.com/nNipsx-Sec/pySigma-backend-qradar";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
