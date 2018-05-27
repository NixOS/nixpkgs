{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8ad8014085628eab91bc82fb9d10cf9ab8e04ede4884e4a1061445d395b36bb";
  };

  propagatedBuildInputs = [ numpy ];

  # Run the test suite.
  # It requires the build path to be in the python search path.
  checkPhase = ''
    ${python}/bin/${python.executable} <<EOF
    import sysconfig
    import sys
    import os
    f = "lib.{platform}-{version[0]}.{version[1]}"
    lib = f.format(platform=sysconfig.get_platform(),
                   version=sys.version_info)
    build = os.path.join(os.getcwd(), 'build', lib)
    sys.path.insert(0, build)
    import numexpr
    r = numexpr.test()
    if not r.wasSuccessful():
        sys.exit(1)
    EOF
  '';

  meta = {
    description = "Fast numerical array expression evaluator for NumPy";
    homepage = "https://github.com/pydata/numexpr";
    license = lib.licenses.mit;
  };
}