{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.6.1";
  pname = "node-semver";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dv6mjsm67l1razcgmq66riqmsb36wns17mnipqr610v0z0zf5j0";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
