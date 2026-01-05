{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  numpy,
  torch,
  typing-extensions,

  # tests
  pytestCheckHook,
  scipy,
}:

buildPythonPackage {
  pname = "asteroid-filterbanks";
  version = "0.4.0-unstable-2024-12-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "asteroid-filterbanks";
    # TODO: 0.4.0 is not compatible with recent torch and numpy
    rev = "74a13c69ba9858d57bd4936f18f3c3bd4b2d580c";
    hash = "sha256-iTwqq5qyTDK9f0MG2XUvYUGSOPJ2I/X/Pxrf+n7o8Mk=";
  };

  patches = [
    (fetchpatch2 {
      name = "numpy2-compat.patch";
      url = "https://github.com/asteroid-team/asteroid-filterbanks/commit/2c22e97c782f0e57e49d2beb56054c71ad5ccb08.patch";
      hash = "sha256-wBwQJzG/ET+XbV39l3UvctwhR/5TG+WgdxrPa/nyhRU=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    torch
    typing-extensions
  ];

  pythonImportsCheck = [ "asteroid_filterbanks" ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  disabledTests = [
    # RuntimeError: cannot cache function '__o_fold': no locator available for file
    # '/nix/store/d1znhn1n48z2raj0j9zbz80hhg4k2shw-python3.12-librosa-0.10.2.post1/lib/python3.12/site-packages/librosa/core/notation.py'
    "test_melgram_encoder"
    "test_melscale"

    # AssertionError: The values for attribute 'shape' do not match
    "test_torch_stft"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Issue with JIT on darwin:
    # RuntimeError: required keyword attribute 'value' has the wrong type
    "test_jit_filterbanks"
    "test_jit_filterbanks_enc"
    "test_pcen_jit"
    "test_stateful_pcen_jit"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Flaky: AssertionError: Tensor-likes are not close!
    "test_fb_def_and_forward_lowdim"
  ];

  meta = {
    description = "PyTorch-based audio source separation toolkit for researchers";
    homepage = "https://github.com/asteroid-team/asteroid-filterbanks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
