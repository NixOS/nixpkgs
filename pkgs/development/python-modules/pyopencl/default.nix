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
  version = "2018.1.1";

  checkInputs = [ pytest ];
  buildInputs = [ opencl-headers ocl-icd ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "29683b47ec729c77a1be4d6fae2bd3718ca4cfcbe14655261a3a14d5bf55530a";
  };

  # py.test is not needed during runtime, so remove it from `install_requires`
  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=2" ""
  '';

  # gcc: error: pygpu_language_opencl.cpp: No such file or directory
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python wrapper for OpenCL";
    homepage = https://github.com/pyopencl/pyopencl;
    license = licenses.mit;
    maintainers = [ maintainers.fridh ];
  };
}
