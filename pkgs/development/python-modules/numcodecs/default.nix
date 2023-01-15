{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools
, setuptools-scm
, cython
, entrypoints
, numpy
, msgpack
, py-cpuinfo
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.11.0";
  format ="pyproject";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bAWLMh3oShcpKZsOrk1lKy5I6hyn+d8NplyxNHDmNes=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    cython
    py-cpuinfo
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
