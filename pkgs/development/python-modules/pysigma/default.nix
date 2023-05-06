{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, packaging
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "pysigma";
  version = "0.9.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "refs/tags/v${version}";
    hash = "sha256-lamd33oHWNhTZ5XGE7g8ztV6Mgh+Gjh2KfoyFjkGmXc=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "packaging"
  ];

  propagatedBuildInputs = [
    packaging
    pyparsing
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require network connection
    "test_sigma_plugin_directory_default"
    "test_sigma_plugin_installation"
  ];

  pythonImportsCheck = [
    "sigma"
  ];

  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
