{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a017b8d9e9da6761f4574642149c337f8f540d4edfe573fb91ad2c4001a2bc76";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with stdenv.lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = https://limits.readthedocs.org/;
  };
}
