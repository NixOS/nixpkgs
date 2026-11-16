{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  makefun,
  multipledispatch,
  numpy,
  opt-einsum,
  typing-extensions,

  # tests
  pyro-ppl,
  torch,
  pandas,
  pillow,
  pyro-api,
  pytestCheckHook,
  pytest-xdist,
  requests,
  scipy,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "funsor";
  version = "0.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "funsor";
    tag = finalAttrs.version;
    hash = "sha256-iTkDd6vz4wesY3jABSMxLtTKioP98DhGB0plLL+vhNY=";
  };

  patches = [
    # Compatibility with torch >= 2.5, where `Uniform.arg_constraints` is a property.
    # Remaining part of the pending upstream PR https://github.com/pyro-ppl/funsor/pull/610
    # (the `Uniform` parameter registration was already merged as part of
    # https://github.com/pyro-ppl/funsor/pull/614).
    ./torch-arg-constraints-property.patch
  ];

  # `torch.cholesky` and `Tensor.cholesky` were removed in torch 2.14
  postPatch = ''
    substituteInPlace test/pyro/test_convert.py test/pyro/test_hmm.py \
      --replace-fail "torch.cholesky(cov)" "torch.linalg.cholesky(cov)"
    substituteInPlace test/test_gaussian.py \
      --replace-fail "u = x.cholesky()" "u = torch.linalg.cholesky(x)"
  '';

  build-system = [ setuptools ];

  dependencies = [
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
    pytestCheckHook
    pytest-xdist
    requests
    scipy
    torchvision
  ];

  preCheck = ''
    export FUNSOR_BACKEND=torch
  '';

  pytestFlags = [
    # FutureWarning: `torch.jit.trace` is not supported in Python 3.14+ and may break.
    "-Wignore:`torch.jit.:FutureWarning"
  ];

  pythonImportsCheck = [ "funsor" ];

  meta = {
    description = "Functional tensors for probabilistic programming";
    homepage = "https://funsor.pyro.ai";
    changelog = "https://github.com/pyro-ppl/funsor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
