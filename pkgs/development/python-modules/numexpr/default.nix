{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee8bc7201aa2f1962c67d27c326a11eef9df887d7b87b1278a1d4e722bf44375";
  };

  propagatedBuildInputs = [ numpy ];

  # Run the test suite.
  # It requires the build path to be in the python search path.
  checkPhase = ''
    pushd $out
    ${python}/bin/${python.executable} <<EOF
    import sys
    import numexpr
    r = numexpr.test()
    if not r.wasSuccessful():
        sys.exit(1)
    EOF
    popd
  '';

  meta = {
    description = "Fast numerical array expression evaluator for NumPy";
    homepage = "https://github.com/pydata/numexpr";
    license = lib.licenses.mit;
  };
}