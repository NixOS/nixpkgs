{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, loguru
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "python-utils";
  version = "3.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-WSP5LQQZnm9k0v/xbsUHgQiwmhcb2Uw9BQurC1ieMjI=";
  };

  postPatch = ''
    sed -i pytest.ini \
      -e '/--cov/d' \
      -e '/--mypy/d'
  '';

  propagatedBuildInputs = [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    loguru = [
      loguru
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
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
