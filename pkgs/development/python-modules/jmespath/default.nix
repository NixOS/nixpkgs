{ stdenv
, buildPythonPackage
, fetchPypi
, ply
, nose
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ ply ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/boto/jmespath";
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = "BSD";
  };

}
