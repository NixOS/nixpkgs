{ lib
, buildPythonPackage
, fetchPypi
, nose
, decorator
}:

buildPythonPackage rec {
  pname = "networkx";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "64272ca418972b70a196cb15d9c85a5a6041f09a2f32e0d30c0255f25d458bb1";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ decorator ];

  meta = {
    homepage = https://networkx.github.io/;
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
