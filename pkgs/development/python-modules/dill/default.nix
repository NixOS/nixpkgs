{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,

  # passthru tests
  apache-beam,
  datasets,
}:

buildPythonPackage (finalAttrs: {
  pname = "dill";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "dill";
    tag = finalAttrs.version;
    hash = "sha256-Yh9WvescLgV7DmxGBTGKsb29+eRzF9qjZMg0DQQyLyY=";
  };

  nativeBuildInputs = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} dill/tests/__main__.py
    runHook postCheck
  '';

  passthru.tests = {
    inherit apache-beam datasets;
  };

  pythonImportsCheck = [ "dill" ];

  meta = {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    changelog = "https://github.com/uqfoundation/dill/releases/tag/dill-${finalAttrs.version}";
    license = lib.licenses.bsd3;
  };
})
