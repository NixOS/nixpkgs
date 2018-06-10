{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "babelfish";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104";
  };

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/babelfish;
    description = "A module to work with countries and languages";
    license = licenses.bsd3;
  };
}
