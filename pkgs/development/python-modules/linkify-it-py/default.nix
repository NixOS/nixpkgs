{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, uc-micro-py
}:

buildPythonPackage rec {
  pname = "linkify-it-py";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1QqfqFdTEdZr02jQnmHmvw3fgnC/ktsfALyhtkGSXoY=";
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
