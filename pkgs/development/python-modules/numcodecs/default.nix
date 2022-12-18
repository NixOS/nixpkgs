{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, cython
, entrypoints
, numpy
, msgpack
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.10.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IoOMaz/Zhr2cckA5uIhwBX95DiKyDm4cu6oN4ULdWcQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
    cython
  ];

  propagatedBuildInputs = [
    entrypoints
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
