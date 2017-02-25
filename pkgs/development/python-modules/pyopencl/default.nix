{ stdenv
, fetchurl
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
  version = "2016.2";
  name = "${pname}-${version}";

  buildInputs = [ pytest opencl-headers ocl-icd ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "1b94540cf59ea71a3ef234a8f1d0eb2b4633c112f0f554fb69e52b4a0337d82b";
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
