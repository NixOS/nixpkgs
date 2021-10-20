{ lib
, buildPythonPackage
, chardet
, fetchFromGitHub
, karton-core
, pytestCheckHook
, python_magic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-classifier";
  version = "1.2.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AG2CtNMgXYfbdlOqB1ZdjMT8H67fsSMXTgiFg6K41IQ=";
  };

  propagatedBuildInputs = [
    chardet
    karton-core
    python_magic
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.4" "chardet" \
      --replace "python-magic==0.4.18" "python-magic"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "karton.classifier" ];

  meta = with lib; {
    description = "File type classifier for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-classifier";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
