{ lib
, buildPythonPackage
, fetchFromGitHub
, dill
, filelock
, fsspec
, huggingface-hub
, multiprocess
, numpy
, pandas
, pyarrow
, requests
, tqdm
, xxhash
}:

buildPythonPackage rec {
  pname = "datasets";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = version;
    hash = "sha256-is8TS84varARWyfeDTbQH0pcYFTk0PcEyK183emB4GE=";
  };

  propagatedBuildInputs = [
    dill
    filelock
    fsspec
    huggingface-hub
    multiprocess
    numpy
    pandas
    pyarrow
    requests
    tqdm
    xxhash
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"tqdm>=4.27,<4.50.0"' '"tqdm>=4.27"' \
      --replace "huggingface_hub==0.0.2" "huggingface_hub>=0.0.2"
  '';

  # Tests require pervasive internet access.
  doCheck = false;

  # Module import will attempt to create a cache directory.
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [ "datasets" ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/datasets";
    description = "Fast, efficient, open-access datasets and evaluation metrics for natural language processing";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk ];
  };
}
