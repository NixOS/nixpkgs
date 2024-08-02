{
  lib,
  fetchPypi,
  fetchFromGitHub,
  buildPythonPackage,
  absl-py,
  nltk,
  numpy,
  six,
  pytestCheckHook,
  pythonOlder,
}:
let
  testdata = fetchFromGitHub {
    owner = "google-research";
    repo = "google-research";
    sparseCheckout = [ "rouge/testdata" ];
    rev = "1d4d2f1aa6f2883a790d2ae46a6ee8ab150d8f31";
    hash = "sha256-ojqk6U2caS7Xz4iGUC9aQVHrKb2QNvMlPuQAL/jJat0=";
  };
in
buildPythonPackage rec {
  pname = "rouge-score";
  version = "0.1.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "rouge_score";
    inherit version;
    extension = "tar.gz";
    hash = "sha256-x9TaJoPmjJq/ATXvkV1jpGZDZm+EjlWKG59+rRf/DwQ=";
  };

  # the tar file from pypi doesn't come with the test data
  postPatch = ''
    substituteInPlace rouge_score/test_util.py \
      --replace 'os.path.join(os.path.dirname(__file__), "testdata")' '"${testdata}/rouge/testdata/"'
  '';

  propagatedBuildInputs = [
    absl-py
    nltk
    numpy
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;

  disabledTests = [
    # https://github.com/google-research/google-research/issues/1203
    "testRougeLSumSentenceSplitting"
    # tries to download external tokenizers via nltk
    "testRougeLsumLarge"
  ];

  pythonImportsCheck = [ "rouge_score" ];

  meta = {
    description = "Python ROUGE Implementation";
    homepage = "https://github.com/google-research/google-research/tree/master/rouge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nviets ];
  };
}
