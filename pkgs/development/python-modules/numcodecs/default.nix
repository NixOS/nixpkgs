{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef4843d5db4d074e607e9b85156835c10d006afc10e175bda62ff5412fca6e4d";
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
