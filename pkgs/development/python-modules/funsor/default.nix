{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, makefun
, multipledispatch
, numpy
, opt-einsum
, typing-extensions
, pyro-ppl
, torch
, pandas
, pillow
, pyro-api
, pytest
, pytest-xdist
, requests
, scipy
, torchvision
}:

buildPythonPackage rec {
  pname = "funsor";
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "funsor";
    rev = "refs/tags/${version}";
    hash = "sha256-Prj1saT0yoPAP8rDE0ipBEpR3QMk4PS12VSJlxc22p8=";
  };

  # Disable the tests that rely on downloading assets from the internet as well as the linting checks.
  patches = [
    ./patch-makefile-for-tests.patch
  ];

  propagatedBuildInputs = [
    makefun
    multipledispatch
    numpy
    opt-einsum
    typing-extensions
  ];

  nativeCheckInputs = [
    # Backend
    pyro-ppl
    torch

    pandas
    pillow
    pyro-api
    pytest
    pytest-xdist
    requests
    scipy
    torchvision
  ];

  # Use the included Makefile to run the tests.
  checkPhase = ''
    export FUNSOR_BACKEND=torch
    make test
  '';

  pythonImportsCheck = [ "funsor" ];

  meta = with lib; {
    description = "Functional tensors for probabilistic programming";
    homepage = "https://funsor.pyro.ai";
    changelog = "https://github.com/pyro-ppl/funsor/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
