{ stdenv
, buildPythonPackage
, fetchPypi
, ply
, nose
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nf2ipzvigspy17r16dpkhzn1bqdmlak162rm8dy4wri2n6mr9fc";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ ply ];

  meta = with stdenv.lib; {
    homepage = https://github.com/boto/jmespath;
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = "BSD";
  };

}
