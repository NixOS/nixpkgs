{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.stream";
  version = "1.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "06qsjyab56vi0ikr819ghb7f8ymf09n92vla7gcn8j12113m2mib";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
