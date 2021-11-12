{ buildPythonPackage, fetchPypi, lib, rdflib, nose }:

buildPythonPackage rec {
  pname = "rdflib-jsonld";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "107cd3019d41354c31687e64af5e3fd3c3e3fa5052ce635f5ce595fd31853a63";
  };

  nativeBuildInputs = [ nose ];
  propagatedBuildInputs = [ rdflib ];

  meta = with lib; {
    homepage = "https://github.com/RDFLib/rdflib-jsonld";
    license = licenses.bsdOriginal;
    description = "rdflib extension adding JSON-LD parser and serializer";
    maintainers = [ maintainers.koslambrou ];
    # incomptiable with rdflib 6.0.0, half of the test suite fails with import and atrribute errors
    broken = true;
  };
}
