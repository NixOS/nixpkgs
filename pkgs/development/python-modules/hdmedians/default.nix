{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  cython,
  oldest-supported-numpy,
  setuptools,
  numpy,
  nose,
}:

buildPythonPackage rec {
  pname = "hdmedians";
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b47aecb16771e1ba0736557255d80ae0240b09156bff434321de559b359ac2d6";
  };

  # nose was marked as a build-time dependency, but is only used for testing
  postPatch = ''
    substituteInPlace setup.py \
        --replace-fail "'nose>=1.0', " ""
  '';

  build-system = [
    cython
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [ numpy ];

  # nose no longer builds on python >=3.12
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    runHook preCheck

    # force python to resolve the package from $out, where the cython ext files actually exist
    mv hdmedians/tests tests
    rm -r hdmedians

    nosetests tests

    runHook postCheck
  '';

  pythonImportsCheck = [
    "hdmedians"
    "hdmedians.geomedian" # ext
  ];

  meta = {
    homepage = "https://github.com/daleroberts/hdmedians";
    description = "High-dimensional medians";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
