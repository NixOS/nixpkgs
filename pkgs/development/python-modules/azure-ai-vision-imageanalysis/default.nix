{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-core,
  isodate,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "azure-ai-vision-imageanalysis";
  version = "1.0.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "refs/tags/azure-ai-vision-imageanalysis_${version}";
    hash = "sha256-Hkj9mrjCc8Li8z6e1BjpzANRVx6+DjN0MhTLANMT78E=";
  };

  sourceRoot = "${src.name}/sdk/vision/azure-ai-vision-imageanalysis";

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
  ];

  pythonImportsCheck = [ "azure.ai.vision.imageanalysis" ];

  doCheck = false; # cannot import 'devtools_testutils'

  meta = {
    homepage = "https://github.com/Kalmat/PyMonCtl";
    license = lib.licenses.bsd3;
    description = "Cross-Platform toolkit to get info on and control monitors connected";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
