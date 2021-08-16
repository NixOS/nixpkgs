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
  version = "0.8.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63e75114131f704ff46ca2fe437fdae6429bfd9b4377e356253eb5dacc9e093a";
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
    homepage = "https://github.com/alimanfoo/numcodecs";
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ maintainers.costrouc ];
  };
}
