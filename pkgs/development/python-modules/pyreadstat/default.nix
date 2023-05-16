{ lib
, stdenv
, buildPythonPackage
, cython
, fetchFromGitHub
, libiconv
, pandas
, python
, pythonOlder
, readstat
, zlib
}:

buildPythonPackage rec {
  pname = "pyreadstat";
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-CvovylOTTyXm0ucTwNSFZzkcA0H8H76BSg4vjB2Pe4M=";
=======
    hash = "sha256-7DpmWIRzhB32YZCDpR+rEIAzn5OuZqt7wvS0GnxnT/g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  propagatedBuildInputs = [
    readstat
    pandas
  ];

  pythonImportsCheck = [
    "pyreadstat"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test_basic.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Module to read SAS, SPSS and Stata files into pandas data frames";
    homepage = "https://github.com/Roche/pyreadstat";
    changelog = "https://github.com/Roche/pyreadstat/blob/v${version}/change_log.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ swflint ];
  };
}
