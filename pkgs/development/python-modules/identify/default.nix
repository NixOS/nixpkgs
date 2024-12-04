{
  lib,
  buildPythonPackage,
  editdistance-s,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  ukkonen,
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    rev = "refs/tags/v${version}";
    hash = "sha256-6sKnHsVLkwHy2udd8znqiFFMfWnmWTxTU949X4bqLNU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    editdistance-s
    pytestCheckHook
    ukkonen
  ];

  pythonImportsCheck = [ "identify" ];

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "identify-cli";
  };
}
