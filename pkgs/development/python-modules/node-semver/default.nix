{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.1.1";
  pname = "node-semver";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3xiqgl436q33grbkh4chpfchl8i2dmcpggbb2q4vgv3vjy97p2";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
