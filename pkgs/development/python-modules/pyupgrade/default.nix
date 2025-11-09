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
  version = "3.21.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "pyupgrade";
    rev = "v${version}";
    hash = "sha256-zbj1NvD74LawB1GIchLtWI/x4iHIHepxu2+5S74vPdo=";
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
