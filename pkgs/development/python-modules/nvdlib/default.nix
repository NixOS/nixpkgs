{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
}:

buildPythonPackage rec {
  pname = "nvdlib";
  version = "0.7.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Vehemont";
    repo = "nvdlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-p2xx+QC0P30FR+nMiFW/PoINbcTM49ufADW9B9u2WxI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "nvdlib"
  ];

  meta = with lib; {
    description = "Module to interact with the National Vulnerability CVE/CPE API";
    homepage = "https://github.com/Vehemont/nvdlib/";
    changelog = "https://github.com/vehemont/nvdlib/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
