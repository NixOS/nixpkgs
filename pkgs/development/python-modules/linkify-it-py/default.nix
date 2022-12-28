{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, uc-micro-py
}:

buildPythonPackage rec {
  pname = "linkify-it-py";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3bgkhIC6tHl5zieiyllvqFCKwLms55m8MGt1xGhQ4Dk=";
  };

  propagatedBuildInputs = [ uc-micro-py ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "linkify_it" ];

  meta = with lib; {
    description = "Links recognition library with full unicode support";
    homepage = "https://github.com/tsutsu3/linkify-it-py";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
