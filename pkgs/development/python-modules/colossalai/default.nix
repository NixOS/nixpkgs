{ lib
, buildPythonPackage
, fetchFromGitHub
, ninja
, pythonRelaxDepsHook
, pythonOlder
# propagated build inputs
, numpy
, tqdm
, psutil
, packaging
, pre-commit
, rich
, click
, fabric
, contexttimer
, torch-bin
, safetensors
, einops
# test dependencies
, pytestCheckHook
, torchvision
, coverage
, transformers
, timm
, torchaudio
, openai-triton
, sentencepiece
, datasets
}:
let
  version = "0.3.3";
in
buildPythonPackage {
  pname = "colossalai";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hpcaitech";
    repo = "ColossalAI";
    rev = "v${version}";
    hash = "sha256-6P9arQyZopGvX79cv6dPu/ifZbQVjd5FAXtWZliM2yA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace requirements/requirements.txt \
      --replace "ninja" ""
  '';


  nativeBuildInputs = [
    ninja
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "ninja"
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
    psutil
    packaging
    pre-commit
    rich
    click
    fabric
    contexttimer
    ninja
    torch-bin
    safetensors
    einops
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # diffusers
    # fbgemm-gpu
    torchvision
    coverage
    transformers
    timm
    # titans
    torchaudio
    # torchrec
    openai-triton
    sentencepiece
    # flash_attn
    datasets
  ];

  pythonImportsCheck = [ "colossalai" ];

  meta = with lib; {
    description = "Making large AI models cheaper, faster and more accessible";
    homepage = "https://github.com/hpcaitech/ColossalAI";
    changelog = "https://github.com/hpcaitech/ColossalAI/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
