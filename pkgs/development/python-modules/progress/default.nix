{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  version = "1.6.1";
  format = "setuptools";
  pname = "progress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wbpxn4Ys6IUjKnWeq0eXH+dN/Hu3arilHvWUC601CGw=";
  };

  checkPhase = ''
    ${python.interpreter} test_progress.py
  '';

  meta = with lib; {
    homepage = "https://github.com/verigak/progress/";
    description = "Easy to use progress bars";
    license = licenses.mit;
    maintainers = [ ];
  };
}
