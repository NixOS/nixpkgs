{ lib
, fetchPypi
, buildPythonPackage
, astropy
, dask
, numpy
, oldest-supported-numpy
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "casa-formats-io";
  version = "0.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8iZ+wcSfh5ACTb3/iQAf2qQpwZ6wExWwcdJoLmCEjB0=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ astropy dask numpy ];

  # Tests require a large (800 Mb) dataset
  doCheck = false;

  pythonImportsCheck = [ "casa_formats_io" ];

  meta = {
    description = "Dask-based reader for CASA data";
    homepage = "https://casa-formats-io.readthedocs.io/";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
