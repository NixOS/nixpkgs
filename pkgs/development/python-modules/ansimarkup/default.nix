{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, colorama
}:

buildPythonPackage rec {
  pname = "ansimarkup";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gvalkov";
    repo = "python-ansimarkup";
    rev = "v${version}";
    sha256 = "sha256-HGeVapv2Z5GtPwSp3+dvUwAH0bFqu+Bmk5E6SRr7NO4=";
  };

  propagatedBuildInputs = [ colorama ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansimarkup" ];

  meta = with lib; {
    description = "An XML-like markup for producing colored terminal text.";
    homepage = "https://github.com/gvalkov/python-ansimarkup";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
  };
}
