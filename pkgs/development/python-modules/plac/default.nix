{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "plac";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ialbert";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EWwDtS2cRLBe4aZuH72hgg2BQnVJQ39GmPx05NxTNjE=";
  };

  # tests are broken, see https://github.com/ialbert/plac/issues/74
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} doc/test_plac.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "plac" ];

  meta = with lib; {
    description = "Parsing the Command Line the Easy Way";
    mainProgram = "plac_runner.py";
    homepage = "https://github.com/micheles/plac";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
