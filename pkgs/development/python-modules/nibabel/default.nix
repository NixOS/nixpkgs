{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, packaging
, pytestCheckHook
, nose
, numpy
, h5py
, pydicom
, scipy
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "4.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RcSbU0k1G0X2wEWpGqArTw02dob/MoRjLvlaxluTB4Y=";
  };

  propagatedBuildInputs = [ numpy scipy h5py packaging pydicom ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/nipy/nibabel/issues/951
    "test_filenames"
  ];

  meta = with lib; {
    homepage = "https://nipy.org/nibabel";
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
