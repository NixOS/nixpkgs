{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  appdirs,
  geojson,
  hatchling,
  requests,
  pytestCheckHook,
  requests-mock,
  pythonOlder,
  versioningit,
}:

buildPythonPackage rec {
  pname = "datapoint";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "EJEP";
    repo = "datapoint-python";
    tag = version;
    hash = "sha256-caIbz/tMQbFKK5UVhYiEnGv3EoI3H2y5V4EDASQ253o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    appdirs
    geojson
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "datapoint" ];

  meta = {
    description = "Python interface to the Met Office's Datapoint API";
    homepage = "https://github.com/EJEP/datapoint-python";
    changelog = "https://github.com/EJEP/datapoint-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
