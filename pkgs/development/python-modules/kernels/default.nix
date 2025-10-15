{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "kernels";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${version}";
    hash = "sha256-L8zm7Cqi/MrtrAs3iGiHsxEqAAIpBCBVn7Mmzyt3MvI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    huggingface-hub
  ];

  # Tests require pervasive internet access
  doCheck = false;

  pythonImportsCheck = [ "kernels" ];

  meta = {
    description = "Load compute kernels from the Huggingface Hub";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
