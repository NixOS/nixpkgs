{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mecab,
  setuptools-scm,
  cython,
}:

buildPythonPackage rec {
  pname = "ipadic";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "polm";
    repo = "ipadic-py";
    tag = "v${version}";
    hash = "sha256-ybC8G1AOIZWkS3uQSErXctIJKq9Y7xBjRbBrO8/yAj4=";
  };

  # no tests
  doCheck = false;

  nativeBuildInputs = [
    cython
    mecab
    setuptools-scm
  ];

  pythonImportsCheck = [ "ipadic" ];

  meta = {
    description = "Contemporary Written Japanese dictionary";
    homepage = "https://github.com/polm/ipadic-py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
