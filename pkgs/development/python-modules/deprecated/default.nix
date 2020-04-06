{ stdenv, fetchPypi, buildPythonPackage,
	wrapt, pytest, tox }:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029mr75wgah0z1ilsf3vf3dmjn65y4fy1jgq5qny2qsb9hvwbblw";
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
