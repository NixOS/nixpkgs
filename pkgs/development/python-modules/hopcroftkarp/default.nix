{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hopcroftkarp";
  version = "1.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28a7887db81ad995ccd36a1b5164a4c542b16d2781e8c49334dc9d141968c0e7";
  };

  # tests fail due to bad package name
  doCheck = false;

  meta = with lib; {
    description = "Implementation of HopcroftKarp's algorithm";
    homepage = "https://github.com/sofiat-olaosebikan/hopcroftkarp";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
