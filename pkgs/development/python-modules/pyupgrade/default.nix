{ lib
, isPy27
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "pyupgrade";
  version = "2.7.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mqsp284db8vb1v7xa3g88vfnn76jv3wn6djimig5w7icqgjyq3z";
  };

  propagatedBuildInputs = [ tokenize-rt ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/asottile/pyupgrade";
    description = "A tool (and pre-commit hook) to automatically upgrade syntax for newer versions of the language.";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
