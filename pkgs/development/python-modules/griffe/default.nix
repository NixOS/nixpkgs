{ lib
, aiofiles
, buildPythonPackage
, colorama
, fetchFromGitHub
, git
, jsonschema
, pdm-backend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "0.36.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tpr26vVsNhCRKUk0Wj07BAEy0iS2pWHoOFQxtrqN9ic=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    colorama
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  pythonImportsCheck = [
    "griffe"
  ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
