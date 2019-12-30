{ buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c16d01cde9c2c955d76d45675e64b06c3255784d49cea4147024e99a01fbbb18";
  };

  patches = [ ./set-compiler-language.patch ];

  checkInputs = [ pytest ];

  # ImportError: Failed to import test module: test.testlucene
  doCheck = false;

  meta = {
    homepage = "https://github.com/originell/jpype/";
    license = "License :: OSI Approved :: Apache Software License";
    description = "A Python to Java bridge.";
  };
}
