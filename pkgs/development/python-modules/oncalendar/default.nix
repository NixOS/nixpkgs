{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "oncalendar";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "cuu508";
    repo = "oncalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-eQYxOnL4/TJbY/nijcPl8TqK2MrwcdISKGfZQoI7828=";
  };

  nativeBuildInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oncalendar" ];

  meta = with lib; {
    description = "A systemd OnCalendar expression parser and evaluator";
    homepage = "https://github.com/cuu508/oncalendar";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
