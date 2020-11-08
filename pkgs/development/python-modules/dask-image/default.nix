{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, dask
, numpy, toolz # dask[array]
, scipy
, pims
, pytest
, pytest-flake8
, scikitimage
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15svy8y57i30878pijyd0pxn10bnk7ffmmgwva5rpip4b7grsgv0";
  };

  nativeBuildInputs = [ pytest-flake8 ];
  requiredPythonModules = [ dask numpy toolz scipy pims ];
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/dask/dask-image";
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
