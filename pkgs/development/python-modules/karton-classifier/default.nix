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
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-DH8I4Lbbs2TVMvYlvh/P2I/7O4+VechP2JDDVHNsTSg=";
=======
    hash = "sha256-TRmAin0TAOIwR5EBMwTOJ9QaHO+mOx/eAjgqvyQZDj4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/CERT-Polska/karton-classifier/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
