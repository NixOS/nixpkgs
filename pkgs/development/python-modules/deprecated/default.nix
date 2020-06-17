{ stdenv, fetchPypi, buildPythonPackage,
	wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x3zkmykcyjn8k57g8lcf89fxw8q7hvvcj6xkwb0f2zrnmpscnsj";
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
