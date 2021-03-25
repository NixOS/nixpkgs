{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ai3i5n07csnzfsxf2dxp8cpdk6ajl5iv8rv0fj6n9ag7qphixac";
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
