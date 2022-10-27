{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html-text";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "TeamHG-Memex";
    repo = "html-text";
    rev = version;
    sha256 = "sha256-jw/hpz0QfcgP5OEJcmre0h1OzOfpPtaROxHm+YUqces=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  checkInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "html_text" ];

  meta = with lib; {
    description = "Extract text from HTML";
    homepage = "https://github.com/TeamHG-Memex/html-text";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
