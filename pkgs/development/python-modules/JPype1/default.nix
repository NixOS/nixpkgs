{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09bzmnzkjbrf60h39wapxc1l8mb3r9km486cly0mm78bv096884r";
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
