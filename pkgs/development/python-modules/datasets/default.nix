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
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    tag = version;
    hash = "sha256-3Q4tNLA9qUb7XdxP1NftYDcVUgq5ol9OZfklhmadk5I=";
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
    changelog = "https://github.com/huggingface/datasets/releases/tag/${src.tag}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
