{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.18.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nkMKy1NAFBG/PuPdj3LAqr0c4UqEM2R2kHKuORql2dw=";
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
