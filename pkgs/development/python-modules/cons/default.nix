{ lib
, buildPythonPackage
, fetchFromGitHub
, logical-unification
, pytestCheckHook
, pytest-html
}:

buildPythonPackage rec {
  pname = "cons";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "python-cons";
    rev = "fbeedfc8a3d1bff4ba179d492155cdd55538365e";
    sha256 = "sha256-ivHFep9iYPvyiBIZKMAzqrLGnQkeuxd0meYMZwZFFH0=";
  };

  propagatedBuildInputs = [
    logical-unification
  ];

  checkInputs = [
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "cons" ];

  meta = with lib; {
    description = "An implementation of Lisp/Scheme-like cons in Python";
    homepage = "https://github.com/pythological/python-cons";
    changelog = "https://github.com/pythological/python-cons/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Etjean ];
  };
}
