{ lib
, buildPythonPackage
, fetchPypi
, numpy
, packaging
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1UMlN0GNGGkbkRXWFdbaoX7oJ1uu8+3xr7v4vGmAYUc=";
  };

  nativeBuildInputs = [
    numpy
  ];

  propagatedBuildInputs = [
    numpy
    packaging
  ];

  preBuild = ''
    # Remove existing site.cfg, use the one we built for numpy
    ln -s ${numpy.cfg} site.cfg
  '';

  checkPhase = ''
    runtest="$(pwd)/numexpr/tests/test_numexpr.py"
    pushd "$out"
    ${python.interpreter} "$runtest"
    popd
  '';

  pythonImportsCheck = [
    "numexpr"
  ];

  meta = with lib; {
    description = "Fast numerical array expression evaluator for NumPy";
    homepage = "https://github.com/pydata/numexpr";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
