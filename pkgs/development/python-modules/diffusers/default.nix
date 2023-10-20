{ lib
, accelerate
, black
, buildPythonPackage
, datasets
, fetchFromGitHub
, filelock
, flake8
, huggingface-hub
, importlib-metadata
, isort
, numpy
, pillow
, pytest
, pytest-timeout
, pytest-xdist
, regex
, requests
, scipy
, tensorboard
, torch
, transformers
}:
buildPythonPackage rec {
  pname = "diffusers";
  version = "0.21.1";
  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-24Q5ReFVWx1uVECrD78gzbu5RUacfZVCGshO1rQG0Xs=";
  };

  propagatedBuildInputs = [
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    pillow
    regex
    requests
    torch
  ];

  passthru.optional-dependencies = rec {
    quality = [
      black
      isort
      flake8
    ];
    training = [
      accelerate
      datasets
      tensorboard
    ];
    test = [
      datasets
      pytest
      pytest-timeout
      pytest-xdist
      scipy
      transformers
    ];
    dev =
      quality
      ++ training
      ++ test;
  };
  doCheck = false;

  pythonImportsCheck = [ "diffusers" ];

  meta = with lib; {
    description = "Diffusion Model for image and audio generation";
    homepage = "https://github.com/huggingface/diffusers";
    changelog = "https://github.com/huggingface/diffusers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elohmeier ];
  };
}

