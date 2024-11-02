{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
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
