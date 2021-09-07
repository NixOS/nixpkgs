{ lib, fetchPypi, buildPythonPackage,
  wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d2de2de7931a968874481ef30208fd4e08da39177d61d3d4ebdf4366e7dbca1";
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
