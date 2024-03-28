{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "razdel";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "natasha";
    repo = "razdel";
    rev = "668dbe191a5cfd94bebf9155e2ffa5f94ff3fe33";
    hash = "sha256-EPiwsbO/Bv0kzFsPyxro3DvZvJR6EXNIslgDnGsgVb8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "razdel" ];
  pythonImportsCheck = [ "razdel" ];

  meta = with lib; {
    description = "Rule-based system for Russian sentence and word tokenization";
    mainProgram = "razdel-ctl";
    homepage = "https://github.com/natasha/razdel";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
