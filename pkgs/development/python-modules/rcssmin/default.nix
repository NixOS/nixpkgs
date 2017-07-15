{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w42l4dhxghcz7pj3q7hkxp015mvb8z2cq9sfxbl31npsfavd1ya";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://opensource.perlig.de/rcssmin/;
    license = licenses.asl20;
    description = "CSS minifier written in pure python";
  };
}
