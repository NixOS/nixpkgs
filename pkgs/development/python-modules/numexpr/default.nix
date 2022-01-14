{ lib
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd779aa44dd986c4ef10163519239602b027be06a527946656207acf1f58113b";
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
