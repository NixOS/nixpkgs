{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  protobuf,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "kagglesdk";
  version = "0.1.38";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kaggle-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1oTqbaOZr/p7JC3BLdYPD/tUkV9TIsztQXF2/rJ5P+4=";
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
    homepage = "https://github.com/Kaggle/kaggle-sdk-python";
    changelog = "https://github.com/Kaggle/kaggle-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
