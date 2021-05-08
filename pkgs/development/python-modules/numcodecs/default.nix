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
  version = "0.7.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "022b12ad83eb623ec53f154859d49f6ec43b15c36052fa864eaf2d9ee786dd85";
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
