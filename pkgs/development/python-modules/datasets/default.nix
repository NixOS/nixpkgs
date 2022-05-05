{ lib
, aiohttp
, buildPythonPackage
, dill
, fetchFromGitHub
, fsspec
, huggingface-hub
, importlib-metadata
, multiprocess
, numpy
, packaging
, pandas
, pyarrow
, pythonOlder
, requests
, responses
, tqdm
, xxhash
}:

buildPythonPackage rec {
  pname = "datasets";
  version = "1.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = version;
    hash = "sha256-2x6DpsDcVF2O5iJKeMEGw/aJwZPc7gSGaK2947c3B6s=";
  };

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
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests require pervasive internet access.
  doCheck = false;

  # Module import will attempt to create a cache directory.
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [
    "datasets"
  ];

  meta = with lib; {
    description = "Open-access datasets and evaluation metrics for natural language processing";
    homepage = "https://github.com/huggingface/datasets";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
