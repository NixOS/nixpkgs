{ lib
, buildPythonPackage
, fetchFromGitHub
, loguru
, pytest-asyncio
, pytest-mypy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O/+jvdzzxUFaQdAfUM9p40fPPDNN+stTauCD993HH6Y=";
  };

  postPatch = ''
    sed -i '/--cov/d' pytest.ini
    sed -i '/--mypy/d' pytest.ini
  '';

  passthru.optional-dependencies = {
    loguru = [
      loguru
    ];
  };

  checkInputs = [
    pytest-asyncio
    pytest-mypy
    pytestCheckHook
  ] ++ passthru.optional-dependencies.loguru;

  pythonImportsCheck = [
    "python_utils"
  ];

  pytestFlagsArray = [
    "_python_utils_tests"
  ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    changelog = "https://github.com/wolph/python-utils/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
