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
  version = "2.6.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${version}";
    hash = "sha256-FKF3+jN5/D0hRSvr90AY/C/5KBx0c7LvR+l12IP+zbU=";
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
