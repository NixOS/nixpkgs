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

  # test
  responses,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "planetary-computer";
  version = "1.0.0.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "planetary-computer-sdk-for-python";
    tag = "v${version}";
    hash = "sha256-NPHUxThSZzENw4W91WAOqChyIl6Z/Afi4mddz+lXlXA=";
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
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
  };

  pythonImportsCheck = [
    "planetary_computer"
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  disabledTests = [
    # tests require network access
    "test_get_adlfs_filesystem"
    "test_get_container_client"
    "test_signing"
  ];

  meta = {
    description = "Planetary Computer SDK for Python";
    homepage = "https://github.com/microsoft/planetary-computer-sdk-for-python";
    changelog = "https://github.com/microsoft/planetary-computer-sdk-for-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "planetarycomputer";
  };
}
