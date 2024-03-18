{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

, setuptools

, gensim
, numpy
, requests
, sentencepiece
, tqdm
}:

buildPythonPackage {
  pname = "bpemb";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bheinzerling";
    repo = "bpemb";
    rev = "c806757255706ad2f63870c06290cb985543db3e";
    hash = "sha256-ssQlGeBZfPy0zOkb2h7QUHVKfrInDNW/UnKQEdpGmf4=";
  };

  patches = [
    (fetchpatch {
      name = "make-content-header-check-more-robust.patch";
      url = "https://github.com/bheinzerling/bpemb/commit/52ceabf4ca8bde1030be43f71f1f3cb292f4beca.patch";
      hash = "sha256-kxyB0pToz78VAEKJvxe93mYxX58/5NxKUrx6jAGAy6s=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    gensim
    numpy
    requests
    sentencepiece
    tqdm
  ];

  # need network connection for tests
  doCheck = false;

  pythonImportsCheck = [
    "bpemb"
  ];

  meta = with lib; {
    description = "Byte-pair embeddings in 275 languages";
    homepage = "https://github.com/bheinzerling/bpemb";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
