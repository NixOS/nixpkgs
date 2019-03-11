{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc218b777cdbb14fa8cff8f28175ee631bacabbdd41ca34e061325b6c44a6fa6";
  };

  # Remove existing site.cfg, use the one we built for numpy.
  preBuild = ''
    rm site.cfg
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
