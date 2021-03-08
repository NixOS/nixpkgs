{ lib, stdenv
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
  version = "0.4.0";
  pname = "dask-image";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6873a39af21b856a4eb7efee6838e6897b1399f21ab9e65403e69eb62f96c2d";
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

  meta = with lib; {
    homepage = "https://github.com/dask/dask-image";
    description = "Distributed image processing";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
