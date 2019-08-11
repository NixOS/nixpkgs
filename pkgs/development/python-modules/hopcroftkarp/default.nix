{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hopcroftkarp";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc6fc7ad348bbe5c9451f8116845c46ae26290c92b2dd14690aae2d55ba5e3a6";
  };

  # tests fail due to bad package name
  doCheck = false;

  meta = with lib; {
    description = "Implementation of HopcroftKarp's algorithm";
    homepage = https://github.com/sofiat-olaosebikan/hopcroftkarp;
    license = licenses.gpl1;
    maintainers = [ maintainers.costrouc ];
  };
}
