{ stdenv, fetchPypi, buildPythonPackage, pytest, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.2.0";
  pname = "node-semver";

  buildInputs = [ pytest tox ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "c32bfc976fd9e003c4a15665e5fe9f337366ba6b60aeb34e4479da9d7bbb0081";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
