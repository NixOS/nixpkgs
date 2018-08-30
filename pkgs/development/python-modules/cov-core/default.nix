{ stdenv, buildPythonPackage, fetchPypi, coverage }:

buildPythonPackage rec {
  pname = "cov-core";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k3np9ymh06yv1ib96sb6wfsxjkqhmik8qfsn119vnhga9ywc52a";
  };

  propagatedBuildInputs = [ coverage ];

  meta = with stdenv.lib; {
    description = "Plugin core for use by pytest-cov, nose-cov and nose2-cov";
  };
}
