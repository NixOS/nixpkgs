{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  pycountry,
  pyrate-limiter,
  requests,
  typing-extensions,
  pytestCheckHook,
  python-dotenv,
  pytest-vcr,
}:

buildPythonPackage rec {
  pname = "psnawp";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "isFakeAccount";
    repo = "psnawp";
    tag = "v${version}";
    hash = "sha256-JS8VGwIsCr21rwjXCRUXsoVHfFyLTZtgp+ZJcXWCCsQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pycountry
    pyrate-limiter
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dotenv
    pytest-vcr
  ];

  # Tests require PlayStation Network credentials
  doCheck = false;

  pythonImportsCheck = [ "psnawp_api" ];

  meta = {
    description = "Python API Wrapper for PlayStation Network API";
    homepage = "https://github.com/isFakeAccount/psnawp";
    changelog = "https://github.com/isFakeAccount/psnawp/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
