{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "plac";
  version = "1.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ialbert";
    repo = "plac";
    tag = "v${version}";
    hash = "sha256-GcPZ9Ufr2NU+95XZRVgB0+cKGAc17kIYxuxYvWiq//4=";
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
    maintainers = [ ];
  };
}
