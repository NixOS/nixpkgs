{ stdenv, buildPythonPackage, fetchPypi, py }:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "iniconfig";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s9z9n4603fdpv2vzh6ddzfgsjmb09n6qalkjl2xwrss6n4jzyg5";
  };

  buildInputs = [ py ];

  # Do not test with pytest because it creates an infinite loop as pytest depends on iniconfig.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/RonnyPfannschmidt/iniconfig";
    description = "Simple parsing of ini files";
    maintainers = with maintainers; [ dasj19 ];
    license = licenses.mit;
  };
}
