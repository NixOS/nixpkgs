{
  lib,
  aiohttp,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  fsspec,
  huggingface-hub,
  importlib-metadata,
  multiprocess,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pythonOlder,
  requests,
  responses,
  tqdm,
  xxhash,
}:

buildPythonPackage rec {
  pname = "datasets";
  version = "2.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9mB4RXJVkmaK+fLEmyZAdf64YKGoAhE3RzMoj4/8K98=";
  };

  # remove pyarrow<14.0.1 vulnerability fix
  postPatch = ''
    substituteInPlace src/datasets/features/features.py \
      --replace "import pyarrow_hotfix" "#import pyarrow_hotfix"
  '';

  propagatedBuildInputs = [
    aiohttp
    dill
    fsspec
    huggingface-hub
    multiprocess
    numpy
    packaging
    pandas
    pyarrow
    requests
    responses
    tqdm
    xxhash
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Tests require pervasive internet access
  doCheck = false;

  # Module import will attempt to create a cache directory
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [ "datasets" ];

  meta = with lib; {
    description = "Open-access datasets and evaluation metrics for natural language processing";
    mainProgram = "datasets-cli";
    homepage = "https://github.com/huggingface/datasets";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
