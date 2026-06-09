{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  protobuf,
  requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kagglesdk";
  version = "0.1.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kagglesdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KzZy7Hghkljdbbp4AnafBmZL+jw/3q44+caSZ1S1mU=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    protobuf
    requests
  ];

  pythonImportsCheck = [ "kagglesdk" ];

  # The two available tests fail with:
  # AssertionError: 'https://api.kaggle.com' != 'https://www.kaggle.com'
  doCheck = false;

  meta = {
    description = "Bindings to access Kaggle endpoints";
    homepage = "https://github.com/Kaggle/kagglesdk";
    changelog = "https://github.com/Kaggle/kagglesdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
