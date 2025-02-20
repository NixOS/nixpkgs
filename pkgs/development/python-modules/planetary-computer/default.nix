{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  packaging,
  pydantic,
  pystac,
  pystac-client,
  python-dotenv,
  pytz,
  requests,

  # optional-dependencies
  adlfs,
  azure-storage-blob,

}:

buildPythonPackage rec {
  pname = "planetary-computer";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "planetary-computer-sdk-for-python";
    tag = "v${version}";
    hash = "sha256-FcTEXtZ2zZQ3i4zmwecaZHdaHni7UbHSF9TDKP/k4sw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    packaging
    pydantic
    pystac
    pystac-client
    python-dotenv
    pytz
    requests
  ];

  optional-dependencies = {
    adlfs = [ adlfs ];
    azure = [ azure-storage-blob ];
    all = [
      adlfs
      azure-storage-blob
    ];
  };

  pythonImportsCheck = [
    "planetary_computer"
  ];

  meta = {
    description = "Planetary Computer SDK for Python";
    homepage = "https://github.com/microsoft/planetary-computer-sdk-for-python";
    changelog = "https://github.com/microsoft/planetary-computer-sdk-for-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "planetarycomputer";
  };
}
