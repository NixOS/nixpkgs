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
  version = "3.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n6WlJc7Hh7SArJ8Z0fikxidtpXaPQvKTDGn6HukL2q8=";
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
