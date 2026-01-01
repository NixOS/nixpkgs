{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  ninja,
  numpy,
  packaging,
  pybind11,
  torch,
  which,
}:

buildPythonPackage rec {
  pname = "monai";
<<<<<<< HEAD
  version = "1.5.1";
  pyproject = true;

=======
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAI";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-GhyUOp/iLpuKKQAwQsA6D7IiW8ym8QTC4OmRxEKydVA=";
    # fix source non-reproducibility due to versioneer + git-archive, as with Numba, Pytensor etc. derivations:
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${src.tag})"/' $out/monai/_version.py
    '';
  };

=======
    hash = "sha256-SUZSWChO0oQlLblPwmCg2zt2Jp5QnpM1CXWnMiOiLhw=";
    # note: upstream consistently seems to modify the tag shortly after release,
    # so best to wait a few days before updating
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'torch>=2.4.1, <2.7.0' 'torch'
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES;
  '';

  build-system = [
    ninja
    which
  ];

  buildInputs = [ pybind11 ];

  dependencies = [
    numpy
    packaging
    torch
  ];

<<<<<<< HEAD
=======
  pythonRelaxDeps = [ "torch" ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  env.BUILD_MONAI = 1;

  doCheck = false; # takes too long; tries to download data

  pythonImportsCheck = [
    "monai"
    "monai.apps"
    "monai.data"
    "monai.engines"
    "monai.handlers"
    "monai.inferers"
    "monai.losses"
    "monai.metrics"
    "monai.optimizers"
    "monai.networks"
    "monai.transforms"
    "monai.utils"
    "monai.visualize"
  ];

<<<<<<< HEAD
  meta = {
    description = "Pytorch framework (based on Ignite) for deep learning in medical imaging";
    homepage = "https://github.com/Project-MONAI/MONAI";
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bcdarwin ];
=======
  meta = with lib; {
    description = "Pytorch framework (based on Ignite) for deep learning in medical imaging";
    homepage = "https://github.com/Project-MONAI/MONAI";
    changelog = "https://github.com/Project-MONAI/MONAI/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
