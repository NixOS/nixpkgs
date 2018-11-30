{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:


buildPythonPackage rec {
  pname = "nose-cprof";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ayy5mbjly9aa9dkgpz0l06flspnxmnj6wxdl6zr59byrrr8fqhw";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "A python nose plugin to profile using cProfile rather than the default Hotshot profiler";
    homepage = https://github.com/msherry/nose-cprof;
    license = licenses.bsd0;
  };

}
