{ stdenv
, fetchPypi
, buildPythonPackage
, Mako
, pytest
, numpy
, cffi
, pytools
, decorator
, appdirs
, six
, opencl-headers
, ocl-icd
}:

buildPythonPackage rec {
  pname = "pyopencl";
  version = "2017.1.1";
  name = "${pname}-${version}";

  buildInputs = [ pytest opencl-headers ocl-icd ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "928c458a463321c6c91e7fa54bf325bf71d7a8aa5ff750ec8fed2472f6aeb323";
  };

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

  meta = {
    description = "Python wrapper for OpenCL";
    homepage = https://github.com/pyopencl/pyopencl;
    license = stdenv.lib.licenses.mit;
    maintainer = stdenv.lib.maintainers.fridh;
  };
}
