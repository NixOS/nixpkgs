{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  bitarray,
  datasets,
  flask,
  python-dotenv,
  ninja,
  scipy,
  tqdm,
  transformers,
  ujson,
  gitpython,
  torch,
  faiss,
}:

buildPythonPackage rec {
  pname = "colbert-ai";
<<<<<<< HEAD
  version = "0.2.22";
=======
  version = "0.2.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "colbert_ai";
<<<<<<< HEAD
    hash = "sha256-AK/P711xXw06cGvpDStbdKK7fEAgc4B861UVwAJqiIY=";
  };

=======
    hash = "sha256-qNb9tOInLysI7Tf45QlgchYNhBXR5AWFdRiYt35iW6s=";
  };

  # ImportError: cannot import name 'AdamW' from 'transformers'
  # https://github.com/stanford-futuredata/ColBERT/pull/390
  postPatch = ''
    substituteInPlace colbert/training/training.py \
      --replace-fail \
      "from transformers import AdamW, get_linear_schedule_with_warmup" \
      "from transformers import get_linear_schedule_with_warmup; from torch.optim import AdamW"
  '';

  pythonRemoveDeps = [ "git-python" ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    setuptools
  ];

  dependencies = [
    bitarray
    datasets
    faiss
    flask
    gitpython
    python-dotenv
    ninja
    scipy
    torch
    tqdm
    transformers
    ujson
  ];

  pythonImportsCheck = [ "colbert" ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "Fast and accurate retrieval model, enabling scalable BERT-based search over large text collections in tens of milliseconds";
    homepage = "https://github.com/stanford-futuredata/ColBERT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bachp
    ];
  };
}
