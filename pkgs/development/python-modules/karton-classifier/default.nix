{ lib
, buildPythonPackage
, chardet
, fetchFromGitHub
, karton-core
, pytestCheckHook
, python-magic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-classifier";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TRmAin0TAOIwR5EBMwTOJ9QaHO+mOx/eAjgqvyQZDj4=";
  };

  propagatedBuildInputs = [
    chardet
    karton-core
    python-magic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "chardet==3.0.4" "chardet" \
      --replace "python-magic==0.4.18" "python-magic"
  '';

  pythonImportsCheck = [
    "karton.classifier"
  ];

  disabledTests = [
    # Tests expecting results from a different version of libmagic
    "test_process_archive_ace"
    "test_process_runnable_win32_lnk"
  ];

  meta = with lib; {
    description = "File type classifier for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-classifier";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
