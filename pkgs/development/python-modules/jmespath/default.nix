{ lib
, buildPythonPackage
, fetchPypi
, ply
, nose
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pJDigO3R9X1t6IY2mS0Ftx6X1pomoZ8Fjs99MER0v14=";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ ply ];

  meta = with lib; {
    homepage = "https://github.com/boto/jmespath";
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = "BSD";
  };

}
