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
  version = "2018.2.1";

  checkInputs = [ pytest ];
  buildInputs = [ opencl-headers ocl-icd ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ed40baccb493e8e9ac394f15c64871954d234fd6d9250c50bee1466d8bd8e48";
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
