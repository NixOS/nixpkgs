{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, setuptools

# passthru tests
, apache-beam
, datasets
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "refs/tags/dill-${version}";
    hash = "sha256-lh1o/TqnqtYN9xTZom33y1/7ZhMEAFpheLdtalwgObQ=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ tjni ];
  };
}
