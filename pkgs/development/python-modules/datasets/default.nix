{ lib
, buildPythonPackage
, fetchFromGitHub
, dill
, filelock
, numpy
, pandas
, pyarrow
, requests
, tqdm
, xxhash
}:

buildPythonPackage rec {
  pname = "datasets";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = version;
    sha256 = "13l52r7nhj2c1a10isy5309d2g6pmaivyqs5w6yjbjj4195jxya5";
  };

  propagatedBuildInputs = [
    dill
    filelock
    numpy
    pandas
    pyarrow
    requests
    tqdm
    xxhash
  ];

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
