{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python,
}:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "progress";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wbpxn4Ys6IUjKnWeq0eXH+dN/Hu3arilHvWUC601CGw=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test_progress.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/verigak/progress/";
    description = "Easy to use progress bars";
    license = licenses.mit;
    maintainers = [ ];
  };
}
