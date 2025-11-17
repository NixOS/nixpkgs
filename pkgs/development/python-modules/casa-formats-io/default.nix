{
  lib,
  astropy,
  buildPythonPackage,
  dask,
  fetchPypi,
  numpy,
  oldest-supported-numpy,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "casa-formats-io";
  version = "0.3.0";
  format = "setuptools";
  prproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "casa_formats_io";
    inherit version;
    hash = "sha256-FpQj0XeZ7vvOzUM/+5qG6FRwNXl3gzoUBItYdQ1M4m4=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [ oldest-supported-numpy ];

  dependencies = [
    astropy
    dask
    numpy
  ];

  # Tests require a large (800 Mb) dataset
  doCheck = false;

  pythonImportsCheck = [ "casa_formats_io" ];

  meta = with lib; {
    description = "Dask-based reader for CASA data";
    homepage = "https://casa-formats-io.readthedocs.io/";
    changelog = "https://github.com/radio-astro-tools/casa-formats-io/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ smaret ];
  };
}
