{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

  # Native build inputs
  cython,
  pythonRelaxDepsHook,
  which,

  # Propagated build inputs
  cffi,
  hydra-core,
  omegaconf,
  sacrebleu,
  numpy,
  regex,
  torch,
  tqdm,
  bitarray,
  torchaudio,
  scikit-learn,
  packaging,

  # Check inputs
  expecttest,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fairseq";
  version = "0.12.3";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XX/grU5ljQCwx33miGoFc/7Uj9fZDtmhm4Fz7L4U+Bc=";
  };

  patches = [
    # https://github.com/facebookresearch/fairseq/pull/5359
    (fetchpatch {
      url = "https://github.com/facebookresearch/fairseq/commit/2fa0768c2115b0a4c207cfa3e1b3e4ff3ad9a00c.patch";
      hash = "sha256-aYYP/knQX6q6vhyA6q9uOOYfRhDAuJCo9QJWfFEDuuA=";
    })
  ];

  nativeBuildInputs = [
    cython
    pythonRelaxDepsHook
    which
  ];

  pythonRelaxDeps = [
    "hydra-core"
    "omegaconf"
  ];

  propagatedBuildInputs = [
    cffi
    hydra-core
    omegaconf
    sacrebleu
    numpy
    regex
    torch
    tqdm
    bitarray
    torchaudio
    scikit-learn
    packaging
  ];

  nativeCheckInputs = [
    expecttest
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fairseq" ];

  preCheck = ''
    export HOME=$TMPDIR
    cd tests
  '';

  pytestFlagsArray = [ "--import-mode append" ];

  disabledTests = [
    # this test requires xformers
    "test_xformers_single_forward_parity"
    "test_mask_for_xformers"
    # this test requires iopath
    "test_file_io_async"
    # these tests require network access
    "test_s2s_transformer_checkpoint"
    "test_librispeech_s2t_transformer_s_checkpoint"
    "test_s2s_transformer_checkpoint"
    "test_waitk_checkpoint"
    "test_sotasty_es_en_600m_checkpoint"
    "test_librispeech_s2t_conformer_s_checkpoint"
    # TODO research failure
    "test_multilingual_translation_latent_depth"
  ];

  disabledTestPaths = [
    # ValueError: mutable default ... for field bar is not allowed: use default_factory
    "test_dataclass_utils.py"
  ];

  meta = with lib; {
    description = "Facebook AI Research Sequence-to-Sequence Toolkit";
    homepage = "https://github.com/pytorch/fairseq";
    license = licenses.mit;
    platforms = platforms.linux;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ happysalada ];
  };
}
