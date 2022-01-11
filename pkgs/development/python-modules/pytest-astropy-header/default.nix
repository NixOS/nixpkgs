{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytest
, pytest-cov
, pytestCheckHook
, numpy
, astropy
, scipy
, h5py
, scikitimage
}:

buildPythonPackage rec {
  pname = "pytest-astropy-header";
  version = "0.1.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y87agr324p6x5gvhziymxjlw54pyn4gqnd49papbl941djpkp5g";
  };
  patches = [ (fetchpatch {
      url = "https://github.com/astropy/pytest-astropy-header/pull/16.patch";
      sha256 = "11ln63zq0kgsdx1jw3prlzpcdbxmc99p9cwr18s0x6apy0k6df31";
    })
    (fetchpatch {
      url = "https://github.com/astropy/pytest-astropy-header/pull/29.patch";
      sha256 = "18l434c926r5z1iq3b6lpnp0lrssszars9y1y9hs6216r60jgjpl";
    })
  ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    numpy
    scipy
    h5py
    scikitimage
    astropy
  ];

  meta = with lib; {
    description = "Plugin to add diagnostic information to the header of the test output";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
