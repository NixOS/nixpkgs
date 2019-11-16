{ stdenv, fetchPypi, buildPythonPackage,
	wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcw9y7dvhwg5flk6wy8aa4kkgpvcqq3q4jd53h54586fp7w85d5";
  };

  postPatch = ''
    # odd broken tests, don't appear in GitHub repo
    rm tests/demo_classic_usage*.py
  '';

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
