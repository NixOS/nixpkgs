{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  tables,
}:

buildPythonPackage rec {
  pname = "deepdish";
  version = "0.3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-av86vvaTzsNEOPGD8p0aLZhiq6J7uVnU8k1W4AfkH/M=";
  };

  postPatch = ''
    substituteInPlace deepdish/core.py \
      --replace-fail "np.ComplexWarning" "np.exceptions.ComplexWarning"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    tables
  ];

  pythonImportsCheck = [ "deepdish" ];

  # nativeCheckInputs = [
  #   pandas
  # ];

  # The tests are broken: `ModuleNotFoundError: No module named 'deepdish.six.conf'`
  doCheck = false;

  meta = {
    description = "Flexible HDF5 saving/loading and other data science tools from the University of Chicago";
    mainProgram = "ddls";
    homepage = "https://github.com/uchicago-cs/deepdish";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
