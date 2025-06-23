{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,

  # passthru tests
  apache-beam,
  datasets,
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = "dill";
    tag = version;
    hash = "sha256-RIyWTeIkK5cS4Fh3TK48XLa/EU9Iwlvcml0CTs5+Uh8=";
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

  meta = with lib; {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    changelog = "https://github.com/uqfoundation/dill/releases/tag/dill-${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tjni ];
  };
}
