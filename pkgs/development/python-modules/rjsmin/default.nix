{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.0.12";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wc62d0f80kw1kjv8nlxychh0iy66a6pydi4vfvhh2shffm935fx";
  };

  # The package does not ship tests, and the setup machinary confuses
  # tests auto-discovery
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://opensource.perlig.de/rjsmin/;
    license = licenses.asl20;
    description = "Javascript minifier written in python";
  };
}
