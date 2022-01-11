{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, cython
, numpy
, msgpack
, pytestCheckHook
, python
, gcc8
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.9.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "35adbcc746b95e3ac92e949a161811f5aa2602b9eb1ef241b5ea6f09bb220997";
  };

  nativeBuildInputs = [
    setuptools-scm
    cython
    gcc8
  ];

  propagatedBuildInputs = [
    numpy
    msgpack
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "$out/${python.sitePackages}/numcodecs"
  ];

  disabledTests = [
    "test_backwards_compatibility"

    "test_encode_decode"
    "test_legacy_codec_broken"
    "test_bytes"
  ];

  meta = with lib;{
    homepage = "https://github.com/zarr-developers/numcodecs";
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ maintainers.costrouc ];
  };
}
