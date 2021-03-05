{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.10.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XYeqyyfwtS7dHLxeVvmcifW6UCOlnSMxqF1vxezBjT8=";
  };

  checkInputs =  [ pytestCheckHook ];

  propagatedBuildInputs = [ tokenize-rt ];

  meta = with lib; {
    description = "A tool to automatically upgrade syntax for newer versions of the language";
    homepage    = "https://github.com/asottile/pyupgrade";
    license     = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
