{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "3.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "pyupgrade";
    rev = "v${version}";
    hash = "sha256-u4tbzxO7Q9+lGoAtg6cs0pyr/VCLmICOt6VVlvPmZV0=";
  };

  propagatedBuildInputs = [ tokenize-rt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyupgrade" ];

  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    mainProgram = "pyupgrade";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
