{ buildPythonPackage
, fetchFromGitHub
, lib
, isPy3k
, cython
, numpy
, toml
, pytest
}:

buildPythonPackage rec {
  pname = "finalfusion";
  version = "0.7.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "finalfusion";
    repo = "finalfusion-python";
    rev = version;
    sha256 = "0pwzflamxqvpl1wcz0zbhhd6aa4xn18rmza6rggaic3ckidhyrh4";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    toml
  ];

  checkInputs = [
    pytest
  ];

  postPatch = ''
    patchShebangs tests/integration
  '';

  checkPhase = ''
    # Regular unit tests.
    pytest

    # Integration tests for command-line utilities.
    PATH=$PATH:$out/bin tests/integration/all.sh
  '';

  meta = with lib; {
    description = "Python module for using finalfusion, word2vec, and fastText word embeddings";
    homepage = "https://github.com/finalfusion/finalfusion-python/";
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.all;
    license = licenses.blueOak100;
  };
}
