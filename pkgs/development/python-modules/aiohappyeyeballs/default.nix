{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # optional-dependencies
  furo,
  myst-parser,
  sphinx,
  sphinxHook,

  # tests
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiohappyeyeballs";
  version = "2.4.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohappyeyeballs";
    tag = "v${version}";
    hash = "sha256-qTbneCb8XsZ+/Tg7JfFT/q67g7vzd11riZn5lI44Ei8=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [ poetry-core ] ++ optional-dependencies.docs;

  optional-dependencies = {
    docs = [
      furo
      myst-parser
      sphinx
      sphinxHook
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohappyeyeballs" ];

  meta = with lib; {
    description = "Happy Eyeballs for pre-resolved hosts";
    homepage = "https://github.com/bdraco/aiohappyeyeballs";
    changelog = "https://github.com/bdraco/aiohappyeyeballs/blob/v${version}/CHANGELOG.md";
    license = licenses.psfl;
    maintainers = with maintainers; [
      fab
      hexa
    ];
  };
}
