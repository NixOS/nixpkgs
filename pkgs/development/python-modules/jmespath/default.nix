{ stdenv
, buildPythonPackage
, fetchPypi
, ply
, nose
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bde2aef6f44302dfb30320115b17d030798de8c4110e28d5cf6cf91a7a31074c";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ ply ];

  meta = with stdenv.lib; {
    homepage = https://github.com/boto/jmespath;
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = "BSD";
  };

}
