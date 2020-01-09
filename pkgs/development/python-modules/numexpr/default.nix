{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c82z0zx0542j9df6ckjz6pn1g13b21hbza4hghcw6vyhbckklmh";
  };

  # Remove existing site.cfg, use the one we built for numpy.
  preBuild = ''
    ln -s ${numpy.cfg} site.cfg
  '';

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
