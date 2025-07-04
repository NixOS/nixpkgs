{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  gensim,
  numpy,
  requests,
  sentencepiece,
  tqdm,
}:

buildPythonPackage {
  pname = "bpemb";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bheinzerling";
    repo = "bpemb";
    rev = "ec85774945ca76dd93c1d9b4af2090e80c5779dc";
    hash = "sha256-nVaMXb5TBhO/vWE8AYAA3P9dSPI8O+rmzFvbEj8VEkE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gensim
    numpy
    requests
    sentencepiece
    tqdm
  ];

  # need network connection for tests
  doCheck = false;

  pythonImportsCheck = [ "bpemb" ];

  meta = with lib; {
    description = "Byte-pair embeddings in 275 languages";
    homepage = "https://github.com/bheinzerling/bpemb";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
