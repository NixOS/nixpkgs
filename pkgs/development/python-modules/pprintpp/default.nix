{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  parameterized,
  pytestCheckHook,
  pynose,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pprintpp";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6oJhCOLH9J3G1mx1KXPD/JdJFCp5jWslTh4wHP28ZAM=";
  };

  patches = [
    # Replace nose-parameterized with parameterized, https://github.com/wolever/pprintpp/pull/21
    (fetchpatch {
      url = "https://github.com/wolever/pprintpp/commit/873217674cc824b4c1cfdad4867c560c60e8d806.patch";
      hash = "sha256-Y+2yVUkDHkwo49ynNHYXVXJpX4DfVYJ0CWKgzFX/HWc=";
    })
    # Remove "U" move from open(), https://github.com/wolever/pprintpp/pull/31
    (fetchpatch {
      name = "remove-u.patch";
      url = "https://github.com/wolever/pprintpp/commit/deec5e5efad562fc2f9084abfe249ed0c7dd65fa.patch";
      hash = "sha256-I84pnY/KyCIPPI9q0uvj64t8oPeMkgVTPEBRANkZNa4=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    parameterized
    pynose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pprintpp" ];

  pytestFlagsArray = [ "test.py" ];

  disabledTests = [
    # AttributeError: 'EncodedFile' object has no attribute 'getvalue'
    "test_pp"
    "test_pp_pprint"
    "test_fmt"
  ];

  meta = with lib; {
    description = "Drop-in replacement for pprint that's actually pretty";
    homepage = "https://github.com/wolever/pprintpp";
    changelog = "https://github.com/wolever/pprintpp/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jakewaksbaum ];
    mainProgram = "pypprint";
  };
}
