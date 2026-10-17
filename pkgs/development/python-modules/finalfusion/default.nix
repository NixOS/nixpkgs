{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  isPy3k,
  cython,
  numpy,
  toml,
  pytest,
}:

buildPythonPackage rec {
  pname = "finalfusion";
  version = "0.7.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = "finalfusion-python";
    rev = version;
    hash = "sha256-BGYPW5xssKjey0b9mlGwnShlGoTrg894oHfjXhV1n18=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    numpy
    toml
  ];

  nativeCheckInputs = [ pytest ];

  postPatch = ''
    patchShebangs tests/integration

    # `np.float` was a deprecated alias of the builtin `float`
    substituteInPlace tests/test_storage.py \
      --replace 'dtype=np.float)' 'dtype=float)'
  '';

  checkPhase = ''
    # Regular unit tests.
    pytest

    # Integration tests for command-line utilities.
    PATH=$PATH:$out/bin tests/integration/all.sh
  '';

  meta = {
    description = "Python module for using finalfusion, word2vec, and fastText word embeddings";
    homepage = "https://github.com/finalfusion/finalfusion-python/";
    maintainers = [ ];
    platforms = lib.platforms.all;
    license = lib.licenses.blueOak100;
  };
}
