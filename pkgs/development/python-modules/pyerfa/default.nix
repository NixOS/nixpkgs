{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, liberfa
, packaging
, numpy
}:

buildPythonPackage rec {
  pname = "pyerfa";
  format = "pyproject";
  version = "1.7.1.1";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09i2qcsvxd3q04a5yaf6fwzg79paaslpksinan9d8smj7viql15i";
  };

  nativeBuildInputs = [ packaging ];
  propagatedBuildInputs = [ liberfa numpy ];
  preBuild = ''
    export PYERFA_USE_SYSTEM_LIBERFA=1
  '';

  meta = with lib; {
    description = "Python bindings for ERFA routines";
    longDescription = ''
        PyERFA is the Python wrapper for the ERFA library (Essential Routines
        for Fundamental Astronomy), a C library containing key algorithms for
        astronomy, which is based on the SOFA library published by the
        International Astronomical Union (IAU). All C routines are wrapped as
        Numpy universal functions, so that they can be called with scalar or
        array inputs.
    '';
    homepage = "https://github.com/liberfa/pyerfa";
    license = licenses.bsd3;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
