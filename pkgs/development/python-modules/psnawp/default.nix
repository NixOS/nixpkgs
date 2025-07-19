{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  poetry-core,
  pycountry,
  pyrate-limiter,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "psnawp";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "YoshikageKira";
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

  pythonImportsCheck = [ "psnawp_api" ];

  # tests access the actual PlayStation Network API
  doCheck = false;

  meta = {
    changelog = "https://codeberg.org/YoshikageKira/psnawp/releases/tag/${src.tag}";
    description = "Python API Wrapper for PlayStation Network API";
    homepage = "https://codeberg.org/YoshikageKira/psnawp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
