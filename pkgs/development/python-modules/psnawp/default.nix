{
  buildPythonPackage,
  fetchFromCodeberg,
  lib,
  poetry-core,
  pycountry,
  pyrate-limiter,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "psnawp";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "YoshikageKira";
    repo = "psnawp";
    tag = "v${version}";
    hash = "sha256-vAz1HDvPRWgrWMKwWNMA2nhA2wLCN92lDb06ZQiZnO0=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "pycountry"
  ];

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
