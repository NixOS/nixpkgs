{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# Native build inputs
, cython
, pythonRelaxDepsHook
, which

# Propagated build inputs
, cffi
, hydra-core
, omegaconf
, sacrebleu
, numpy
, regex
, torch
, tqdm
, bitarray
, torchaudio
, scikit-learn
, packaging

# Check inputs
, expecttest
, hypothesis
, pytestCheckHook
}:
let
  pname = "fairseq";
  version = "0.12.3";
in
buildPythonPackage rec {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XX/grU5ljQCwx33miGoFc/7Uj9fZDtmhm4Fz7L4U+Bc=";
  };

  disabled = pythonOlder "3.7";

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

  pytestFlagsArray = [
    "--import-mode append"
  ];
  disabledTests = [
    # this test requires xformers
    "test_xformers_single_forward_parity"
    # this test requires iopath
    "test_file_io_async"
    # these tests require network access
    "test_s2s_transformer_checkpoint"
    "test_librispeech_s2t_transformer_s_checkpoint"
    "test_s2s_transformer_checkpoint"
    "test_waitk_checkpoint"
    "test_sotasty_es_en_600m_checkpoint"
    "test_librispeech_s2t_conformer_s_checkpoint"
  ];

  meta = with lib; {
    description = "Facebook AI Research Sequence-to-Sequence Toolkit";
    homepage = "https://github.com/pytorch/fairseq";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ happysalada ];
  };
}
