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
  version = "0.9.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c23803671a3d920efa175af5828870bdff60ba2a3fcbf1d5b48bb81d68219c6";
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
