{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "add-trailing-comma";
    rev = "v${version}";
    hash = "sha256-B+wjBy42RwabVz/6qEMGpB0JmwJ9hqSskwcNj4x/B/k=";
  };

  propagatedBuildInputs = [ tokenize-rt ];

  pythonImportsCheck = [ "add_trailing_comma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    mainProgram = "add-trailing-comma";
    homepage = "https://github.com/asottile/add-trailing-comma";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
