{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pythonOlder,
  setuptools,
  setuptools-scm,
  scipy,
}:

buildPythonPackage rec {
  pname = "dmsuite";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IqLsHkGNgPz2yZm0QMyMMo6Mr2RsU2DPGxYpoNwC3fs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "dmsuite" ];

  meta = {
    description = "Scientific library providing a collection of spectral collocation differentiation matrices";
    homepage = "https://github.com/labrosse/dmsuite";
    changelog = "https://github.com/labrosse/dmsuite/releases/tag/v${version}";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
