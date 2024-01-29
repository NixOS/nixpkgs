{ lib
, buildPythonPackage
, fetchPypi
, nose
}:


buildPythonPackage rec {
  pname = "nose-cprof";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0178834759b63dc50388444d4ff8d1ae84e1ba110bb167419afee6bf4699b119";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler";
    homepage = "https://github.com/msherry/nose-cprof";
    license = licenses.bsd0;
  };

}
