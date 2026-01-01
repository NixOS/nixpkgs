{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymeeus,
  pytz,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Utils for converting between date formats and calculating holidays";
    mainProgram = "censusgeocode";
    homepage = "https://github.com/fitnr/convertdate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
=======
  meta = with lib; {
    description = "Utils for converting between date formats and calculating holidays";
    mainProgram = "censusgeocode";
    homepage = "https://github.com/fitnr/convertdate";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
