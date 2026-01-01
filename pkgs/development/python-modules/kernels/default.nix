{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "kernels";
<<<<<<< HEAD
  version = "0.11.5";
=======
  version = "0.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nPb0MvH3bvxNo64JkhhmrfI8YpSTxQif1+Pk35ywKDI=";
=======
    hash = "sha256-ITrriB3G7tuNaGSMDB2o+RqQO7TKerq9F02u1DtzhmM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
