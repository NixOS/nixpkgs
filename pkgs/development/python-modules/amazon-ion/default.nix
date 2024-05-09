{ lib
, buildPythonPackage
, cbor2
, docopt
, fetchFromGitHub
, jsonconversion
, pytestCheckHook
, pythonOlder
, setuptools
, six
, tabulate
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amazon-ion";
    repo = "ion-python";
    rev = "refs/tags/v${version}";
    # Test vectors require git submodule
    fetchSubmodules = true;
    hash = "sha256-L21FYl4Q+nhB3CU1maOxBHSLU+ox1POHtMio8SSZ/r0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jsonconversion
    six
  ];

  nativeCheckInputs = [
    cbor2
    docopt
    pytestCheckHook
    tabulate
  ];

  disabledTests = [
    # ValueError: Exceeds the limit (4300) for integer string conversion
    "test_roundtrips"
  ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmark_cli.py"
  ];

  pythonImportsCheck = [
    "amazon.ion"
  ];

  meta = with lib; {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amazon-ion/ion-python";
    changelog = "https://github.com/amazon-ion/ion-python/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
