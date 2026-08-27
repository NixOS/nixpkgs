{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "plac";
  version = "1.4.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ialbert";
    repo = "plac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5bYQaZwojGSsfVvF4gkYczpUF77IdptFq1wG2vA4km4=";
  };

  # tests are broken, see https://github.com/ialbert/plac/issues/74
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} doc/test_plac.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "plac" ];

  meta = {
    description = "Parsing the Command Line the Easy Way";
    mainProgram = "plac_runner.py";
    homepage = "https://github.com/micheles/plac";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
})
