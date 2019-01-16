{ buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six }:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "4.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1d09zpi593bhr56rwm41kzffr18wif98plgy6xdy0zrbdwfarrxl";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ inflect more-itertools six ];
}
