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
  versioningit,
}:

buildPythonPackage rec {
  pname = "datapoint";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Perseudonymous";
    repo = "datapoint-python";
    tag = version;
    hash = "sha256-vgwuoG/2Lzo56cAiXEYNPsXQYfx8Cwg0NJgojDBxoug=";
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
    homepage = "https://github.com/Perseudonymous/datapoint-python";
    changelog = "https://github.com/Perseudonymous/datapoint-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
