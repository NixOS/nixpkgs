{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97c1f7fa409439ae933494014cd41d43de84cfe6c98b7f93392f94d54de1b453";
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