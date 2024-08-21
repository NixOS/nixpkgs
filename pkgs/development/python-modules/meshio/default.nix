{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  netcdf4,
  h5py,
  exdown,
  pytestCheckHook,
  rich,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meshio";
  version = "5.3.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8h8Bq9nym6BuoRkwSz055hBCHP6Tud0jNig0kZ+HWG0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    netcdf4
    h5py
    rich
  ];

  nativeCheckInputs = [
    exdown
    pytestCheckHook
  ];

  pythonImportsCheck = [ "meshio" ];

  meta = with lib; {
    homepage = "https://github.com/nschloe/meshio";
    description = "I/O for mesh files";
    mainProgram = "meshio";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
