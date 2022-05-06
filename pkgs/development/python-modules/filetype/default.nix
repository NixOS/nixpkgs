{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ahBHYv6T11XJYqqWyz2TCkj5GgdhBHEmxe6tIVPjOwM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "filetype"
  ];

  disabledTests = [
    # https://github.com/h2non/filetype.py/issues/119
    "test_guess_memoryview"
    "test_guess_extension_memoryview"
    "test_guess_mime_memoryview"
  ];

  disabledTestPaths = [
    # We don't care about benchmarks
    "tests/test_benchmark.py"
  ];

  meta = with lib; {
    description = "Infer file type and MIME type of any file/buffer";
    homepage = "https://github.com/h2non/filetype.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
