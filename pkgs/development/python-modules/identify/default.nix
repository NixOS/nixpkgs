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
  version = "2.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    rev = "refs/tags/v${version}";
    hash = "sha256-EbJiMTDE9eumhkWTXlcB38rHrX5DPAZdqix2H4ocnkE=";
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
