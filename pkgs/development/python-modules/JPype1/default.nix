{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6841523631874a731e1f94e1b1f130686ad3772030eaa3b6946256eeb1d10dd1";
  };

  patches = [ ./set-compiler-language.patch ];

  # Test loader complains about non-test module on python3.
  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/originell/jpype/";
    license = "License :: OSI Approved :: Apache Software License";
    description = "A Python to Java bridge.";
  };
}
