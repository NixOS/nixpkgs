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
, pybind11
}:

buildPythonPackage rec {
  pname = "pyopencl";
  version = "2019.1";

  checkInputs = [ pytest ];
  buildInputs = [ opencl-headers ocl-icd pybind11 ];

  propagatedBuildInputs = [ numpy cffi pytools decorator appdirs six Mako ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "04ahndgc5aqm3pqix2j4vzn9n3k762ylf3yq55jdbxm5cicz9nx0";
  };

  # py.test is not needed during runtime, so remove it from `install_requires`
  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=2" ""
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
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
