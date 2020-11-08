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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = version;
    sha256 = "14f7847b8md5kf631zl8x2f53wy8zbzxypq4wdgzvwsjz4k7v4jn";
  };

  requiredPythonModules = [
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
