{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools_scm
, cython
, numpy
, msgpack
, pytestCheckHook
, python
, gcc8
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.7.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a038064d5604e6181a64db668d7b700d9ae87e4041984c04cbf0042469664b0";
  };

  nativeBuildInputs = [
    setuptools_scm
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
    homepage = "https://github.com/alimanfoo/numcodecs";
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ maintainers.costrouc ];
  };
}
