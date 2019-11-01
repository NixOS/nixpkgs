{ buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1630439d5b0fb49e2878b43a1a1f074f9d4f46520f525569e14f1f0f9399f871";
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
