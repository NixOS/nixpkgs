{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "backports_abc";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    homepage = https://github.com/cython/backports_abc;
    license = lib.licenses.psfl;
    description = "A backport of recent additions to the 'collections.abc' module";
  };
}