{ lib, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "pyprof2calltree";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38a0774f7716d5303d4c57ff89ec24258154942666e4404558f6ac10f8bb1e52";
  };

  doCheck = false;

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    homepage = https://pypi.python.org/pypi/pyprof2calltree/;
    license = licenses.mit;
    maintainer = sfrijters;
  };
}
