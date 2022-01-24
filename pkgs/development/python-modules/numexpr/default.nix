{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fec076b76c90a5f3929373f548834bb203c6d23a81a895e60d0fe9cca075e99";
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
