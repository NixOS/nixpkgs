{ lib
, buildPythonPackage
, fetchPypi
, dask
, numpy, toolz # dask[array]
, scipy
, pims
, pytest
, pytest-flake8
, scikitimage
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bf7ea8dcd9d795505b498bd632394720c048f50761e23c574d9a6bacfb27cbb";
  };

  nativeBuildInputs = [ pytest-flake8 ];
  propagatedBuildInputs = [ dask numpy toolz scipy pims ];
  checkInputs = [
    pytest
    scikitimage
  ];

  # ignore errors from newer versions of flake8
  prePatch = ''
    substituteInPlace setup.cfg \
      --replace "docs/conf.py,versioneer.py" \
        "docs/conf.py,versioneer.py,dask_image/ndfilters/_utils.py"
  '';

  # scikit.external is not exported
  checkPhase = ''
    pytest --ignore=tests/test_dask_image/
  '';
  pythonImportsCheck = [ "dask_image" ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-image";
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
