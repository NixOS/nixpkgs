{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "node-semver";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b87e335179d874a3dd58041198b2715ae70fd20eba81683acde3553c51b28f8e";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
