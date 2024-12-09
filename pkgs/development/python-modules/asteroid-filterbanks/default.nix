{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage rec {
  pname = "asteroid-filterbanks";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asteroid-team";
    repo = "asteroid-filterbanks";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z5M2Xgj83lzqov9kCw/rkjJ5KXbjuP+FHYCjhi5nYFE=";
  };

  # np.float is deprecated
  postPatch = ''
    substituteInPlace asteroid_filterbanks/multiphase_gammatone_fb.py \
      --replace-fail "np.float(" "float("
  '';

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

  disabledTests =
    [
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
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
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
