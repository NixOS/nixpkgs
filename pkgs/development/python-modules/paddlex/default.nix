{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pillow,
  pyyaml,
  chardet,
  colorlog,
  filelock,
  pandas,
  prettytable,
  py-cpuinfo,
  pydantic,
  requests,
  ruamel-yaml,
  typing-extensions,
  ujson,
  distutils,
  huggingface-hub,
<<<<<<< HEAD
  modelscope,
  aistudio-sdk,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

let
  gputil = buildPythonPackage rec {
    pname = "gputil";
    version = "1.4.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "anderskm";
      repo = "gputil";
      tag = "v${version}";
      hash = "sha256-iOyB653BMmDBtK1fM1ZyddjlnaypsuLMOV0sKaBt+yE=";
    };

    build-system = [ setuptools ];

    dependencies = [ distutils ];

    pythonImportsCheck = [ "GPUtil" ];

    meta = {
      homepage = "https://github.com/anderskm/gputil";
      license = lib.licenses.mit;
      description = "Getting GPU status from NVIDA GPUs using nvidia-smi";
      changelog = "https://github.com/anderskm/gputil/releases/tag/${src.tag}";
    };
  };
in
buildPythonPackage rec {
  pname = "paddlex";
<<<<<<< HEAD
  version = "3.3.10";
=======
  version = "3.3.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "PaddleX";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zP9MogxeKbnWtbMM6Kz6ItmSdqTZN5U6d1GkskFJhsI=";
=======
    hash = "sha256-rxVfkvi/uOetMbR3pHN+apjqtvgTq5rwLc0gkhI6OvU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

<<<<<<< HEAD
=======
  pythonRemoveDeps = [
    # unpackaged
    "aistudio-sdk"
    "modelscope"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonRelaxDeps = [
    "numpy"
    "pandas"
    "pyyaml"
  ];

  dependencies = [
    chardet
    colorlog
    filelock
    numpy
    pandas
    pillow
    prettytable
    py-cpuinfo
    pydantic
    pyyaml
    requests
    ruamel-yaml
    typing-extensions
    ujson
    gputil
    huggingface-hub
<<<<<<< HEAD
    modelscope
    aistudio-sdk
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/PaddlePaddle/PaddleX";
    license = lib.licenses.asl20;
    description = "All-in-One Development Tool based on PaddlePaddle";
    changelog = "https://github.com/PaddlePaddle/PaddleX/releases/tag/${src.tag}";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
