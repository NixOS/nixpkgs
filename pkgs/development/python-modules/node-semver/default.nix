{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "node-semver";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7afc1eb3cf098f90fdf9059167c0b314d6717a3216bd5bd6c1676bb7bbe279c";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
