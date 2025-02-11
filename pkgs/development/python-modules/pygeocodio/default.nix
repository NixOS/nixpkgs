{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  httpretty,
}:

buildPythonPackage rec {
  pname = "pygeocodio";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "pygeocodio";
    tag = "v${version}";
    hash = "sha256-s6sY+iHuWv7+6ydxDWoN9eKiAXw0jeASWiMtz12TTHo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    httpretty
  ];

  pythonImportsCheck = [ "geocodio" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python wrapper for the Geocodio geolocation service API";
    downloadPage = "https://github.com/bennylope/pygeocodio/tree/master";
    changelog = "https://github.com/bennylope/pygeocodio/blob/v${version}/HISTORY.rst";
    homepage = "https://www.geocod.io/docs/#introduction";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
