{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZrVs1kdL9B2MVGYDR9N6/MP30ZcGSN42XBAu93VIqts=";
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
    # https://github.com/h2non/filetype.py/issues/128
    "test_guess_zstd"
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
