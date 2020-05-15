{ stdenv, fetchPypi, buildPythonPackage,
	wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k7c5kkh8jxxqdm0cbcvmhn3mwj0rcjwapwbzmm5r04n78lpvwqc";
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
