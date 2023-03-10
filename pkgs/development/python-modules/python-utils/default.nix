{ lib
, stdenv
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
  version = "3.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FFBWkq7ct4JWSTH4Ldg+pbG/BAiW33puB7lqFPBjptw=";
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

  nativeCheckInputs = [
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

  disabledTests = lib.optionals stdenv.isDarwin [
    # Flaky tests on darwin
    "test_timeout_generator"
  ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    changelog = "https://github.com/wolph/python-utils/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
