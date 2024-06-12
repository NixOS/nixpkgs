{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyopenweathermap";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freekode";
    repo = "pyopenweathermap";
    # https://github.com/freekode/pyopenweathermap/issues/2
    rev = "f8541960571591f47d74268d400dfd0d6c9adf67";
    hash = "sha256-hQotoRbTbcsDTwZ3/A4HkWi2ma3b9L0vvwH9ej8k1eE=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/freekode/pyopenweathermap/pull/3
      name = "pytest-network-mark.patch";
      url = "https://github.com/freekode/pyopenweathermap/commit/580ce4317fdffb267fc9122c3c2f8355f1178502.patch";
      hash = "sha256-dHopNTVO1sZgcMUYE1GrrMjbkwSFxNELIfXe2SyQrhw=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-m"
    "'not network'"
  ];

  pythonImportsCheck = [ "pyopenweathermap" ];

  meta = with lib; {
    description = "Python library for OpenWeatherMap API for Home Assistant";
    homepage = "https://github.com/freekode/pyopenweathermap";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
