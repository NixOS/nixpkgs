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
  version = "2017.1";
  name = "${pname}-${version}";

  buildInputs = [ pytest opencl-headers ocl-icd ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "b5085b6412e5a1037b893853e4e47ecb36dd04586b0f8e1809f50f7fe1437dae";
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
