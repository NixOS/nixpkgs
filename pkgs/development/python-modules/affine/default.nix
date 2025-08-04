{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "affine";
  version = "2.4.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ok2BjWqDbBMZdtIvjCe408oy0K9kwdjSnet7r6TaHuo=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/rasterio/affine/blob/${version}/CHANGES.txt";
    description = "Matrices describing affine transformation of the plane";
    license = licenses.bsd3;
    homepage = "https://github.com/rasterio/affine";
    maintainers = with maintainers; [ ];
  };
}
