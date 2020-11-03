{ buildPythonPackage, fetchPypi, lib, rdflib, nose }:

buildPythonPackage rec {
  pname = "rdflib-jsonld";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f7d55326405071c7bce9acf5484643bcb984eadb84a6503053367da207105ed";
  };

  nativeBuildInputs = [ nose ];
  requiredPythonModules = [ rdflib ];

  meta = with lib; {
    homepage = "https://github.com/RDFLib/rdflib-jsonld";
    license = licenses.bsdOriginal;
    description = "rdflib extension adding JSON-LD parser and serializer";
    maintainers = [ maintainers.koslambrou ];
  };
}
