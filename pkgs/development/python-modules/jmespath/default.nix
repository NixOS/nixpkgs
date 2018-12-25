{ stdenv
, buildPythonPackage
, fetchPypi
, ply
, nose
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ ply ];

  meta = with stdenv.lib; {
    homepage = https://github.com/boto/jmespath;
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = "BSD";
  };

}
