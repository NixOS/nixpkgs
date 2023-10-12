{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jinja2
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
  version = "0.10.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "refs/tags/v${version}";
    hash = "sha256-iiE6XHj5632sBlivUHz7HiNRjNpEh+OMqcJ65o2km6I=";
  };

  pythonRelaxDeps = [
    "packaging"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    jinja2
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
