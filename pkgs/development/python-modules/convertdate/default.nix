{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymeeus,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fitnr";
    repo = "convertdate";
    rev = "v${version}";
    hash = "sha256-iOHK3UJulXJJR50nhiVgfk3bt+CAtG3BRySJ8DkBuJE=";
  };

  propagatedBuildInputs = [
    pymeeus
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "convertdate" ];

  meta = {
    description = "Utils for converting between date formats and calculating holidays";
    mainProgram = "censusgeocode";
    homepage = "https://github.com/fitnr/convertdate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
