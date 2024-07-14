{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  version = "1.6";
  format = "setuptools";
  pname = "progress";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ychumLXAP6H+EeO2fB/tpHiLjQ/nM2wv99VkTM+6NM0=";
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
