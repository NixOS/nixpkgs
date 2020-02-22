{ stdenv, fetchPypi, buildPythonPackage,
	wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "408038ab5fdeca67554e8f6742d1521cd3cd0ee0ff9d47f29318a4f4da31c308";
  };

  propagatedBuildInputs = [ wrapt ];
  checkInputs = [ pytest ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
