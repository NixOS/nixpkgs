{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  pytestCheckHook,
  scipy,
  setuptools,
  tables,
}:

buildPythonPackage rec {
  pname = "flammkuchen";
  version = "1.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z68HBsU9J6oe8+YL4OOQiMYQRs3TZUDM+e2ssqo6BFI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
    tables
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/portugueslab/flammkuchen";
    description = "Flexible HDF5 saving/loading library forked from deepdish (University of Chicago) and maintained by the Portugues lab";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
