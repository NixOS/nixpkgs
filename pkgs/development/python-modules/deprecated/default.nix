{ lib, fetchPypi, buildPythonPackage,
  wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "471ec32b2755172046e28102cd46c481f21c6036a0ec027521eba8521aa4ef35";
  };

  propagatedBuildInputs = [ wrapt ];
  checkInputs = [ pytest ];
  meta = with lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
