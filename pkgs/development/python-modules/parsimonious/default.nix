{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "parsimonious";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3add338892d580e0cb3b1a39e4a1b427ff9f687858fdd61097053742391a9f6b";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/erikrose/parsimonious";
    description = "Fast arbitrary-lookahead parser written in pure Python";
    license = licenses.mit;
  };

}
