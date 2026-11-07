{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core_3,
  attrs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "affine";
  version = "3.0.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4bPDjF1NPvUCShgqbRvx4MUasiGCV4HHQa600MB5p+I=";
  };

  build-system = [ flit-core_3 ];

  dependencies = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/rasterio/affine/blob/${version}/CHANGES.txt";
    description = "Matrices describing affine transformation of the plane";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/rasterio/affine";
    maintainers = [ ];
  };
}
