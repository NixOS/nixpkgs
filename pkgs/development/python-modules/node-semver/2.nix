{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.2.0";
  pname = "node-semver";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1080pdxrvnkr8i7b7bk0dfx6cwrkkzzfaranl7207q6rdybzqay3";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
