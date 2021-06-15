{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43616529f9b7d1afc83386f943dc66c4da5e052f00217ba7e3ad8dd1b5f3a825";
  };

  # Remove existing site.cfg, use the one we built for numpy.
  preBuild = ''
    ln -s ${numpy.cfg} site.cfg
  '';

  nativeBuildInputs = [
    numpy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    runtest="$(pwd)/numexpr/tests/test_numexpr.py"
    pushd "$out"
    ${python.interpreter} "$runtest"
    popd
  '';

  meta = {
    description = "Fast numerical array expression evaluator for NumPy";
    homepage = "https://github.com/pydata/numexpr";
    license = lib.licenses.mit;
  };
}
