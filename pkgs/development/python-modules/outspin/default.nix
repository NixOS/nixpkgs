{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook
}:

buildPythonPackage rec {
  pname = "outspin";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "outspin";
    rev = "refs/tags/v${version}";
    hash = "sha256-j+J3n/p+DcfnhGfC4/NDBDl5bF39L5kIPeGJW0Zm7ls=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "outspin" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/outspin/blob/${src.rev}/CHANGELOG.md";
    description = "Conveniently read single char inputs in the console";
    license = licenses.mit;
    maintainers = with maintainers; [ sigmanificient ];
  };
}
