{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, mecab
, setuptools-scm
, cython
}:

buildPythonPackage rec {
  pname = "ipadic";
  version = "1.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "polm";
    repo = "ipadic-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-ybC8G1AOIZWkS3uQSErXctIJKq9Y7xBjRbBrO8/yAj4=";
  };

  # no tests
  doCheck = false;

  nativeBuildInputs = [ cython mecab setuptools-scm ];

  pythonImportsCheck = [ "ipadic" ];

  meta = with lib; {
    description = "Contemporary Written Japanese dictionary";
    homepage = "https://github.com/polm/ipadic-py";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
