{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.16.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U1Ak0oGy0FxBMqRM2A3N7VuNDz2aUW4FFW+hKKhjfdk=";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ tokenize-rt ];

  pythonImportsCheck = [ "pyupgrade" ];

  meta = with lib; {
    description = "Tool to automatically upgrade syntax for newer versions of the language";
    homepage = "https://github.com/asottile/pyupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
