{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, setuptools

# passthru tests
, apache-beam
, datasets
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-r65JgQH+5raiRX8NYELUB9B0zLy4z606EkFJaNpapNc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
