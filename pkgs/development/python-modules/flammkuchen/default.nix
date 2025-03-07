{
  lib,
  buildPythonPackage,
  fetchpatch2,
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
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z68HBsU9J6oe8+YL4OOQiMYQRs3TZUDM+e2ssqo6BFI=";
  };

  patches = [
    (fetchpatch2 {
      name = "numpy-v2-compat.patch";
      url = "https://github.com/portugueslab/flammkuchen/commit/c523ea78e10facd98d4893f045249c68bae17940.patch?full_index=1";
      hash = "sha256-/goNkiEBrcprywQYf2oKvGbu5j12hmalPuB45wNNt+I=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
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
