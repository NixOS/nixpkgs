{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "plac";
  version = "1.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ialbert";
    repo = "plac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5bYQaZwojGSsfVvF4gkYczpUF77IdptFq1wG2vA4km4=";
  };

  build-system = [ setuptools ];

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
    homepage = "https://github.com/micheles/plac";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
    mainProgram = "plac_runner.py";
  };
})
