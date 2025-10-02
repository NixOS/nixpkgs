{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  httpretty,
}:

buildPythonPackage rec {
  pname = "pygeocodio";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "pygeocodio";
    tag = "v${version}";
    hash = "sha256-4jT/PX+jvJx81eaSXTsb/vLNbv4dNNVgeYrE7QwGlL8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    httpretty
  ];

  pythonImportsCheck = [ "geocodio" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_timeout"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python wrapper for the Geocodio geolocation service API";
    downloadPage = "https://github.com/bennylope/pygeocodio/tree/master";
    changelog = "https://github.com/bennylope/pygeocodio/blob/${src.tag}/HISTORY.rst";
    homepage = "https://www.geocod.io/docs/#introduction";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
