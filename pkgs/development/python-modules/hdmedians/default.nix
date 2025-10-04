{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  numpy,
  oldest-supported-numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.14.2";
  pname = "hdmedians";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tHrssWdx4boHNlVyVdgK4CQLCRVr/0NDId5VmzWawtY=";
  };

  patches = [
    # https://github.com/daleroberts/hdmedians/pull/10
    ./replace-nose.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'nose>=1.0'," ""
  '';

  build-system = [
    cython
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "hdmedians" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    cd $out
  '';

  meta = with lib; {
    homepage = "https://github.com/daleroberts/hdmedians";
    description = "High-dimensional medians";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
