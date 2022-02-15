{ lib
, fetchPypi
, buildPythonPackage
, astropy
, dask
, numpy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "casa-formats-io";
  version = "0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16rypj65wdfxxrilxfhbk563lxv86if4vvs9zfq3f8bkzdr8xl9s";
  };

  nativeBuildInputs = [ setuptools-scm ];

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

