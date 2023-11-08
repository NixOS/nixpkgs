{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, python3Packages
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # test vectors require git submodule
  src = fetchFromGitHub {
    owner = "amzn";
    repo = "ion-python";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-YUShPcD0KSayhn52jn2qUzjyAH2M1glFKCrd/faztGY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = with python3Packages; [
    cbor
    cbor2
    docopt
    jsonconversion
    protobuf
    python-rapidjson
    simplejson
    six
    tabulate
    ujson
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # ValueError: Exceeds the limit (4300) for integer string conversion
    "test_roundtrips"
  ];

  pythonImportsCheck = [
    "amazon.ion"
  ];

  meta = with lib; {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amzn/ion-python";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
