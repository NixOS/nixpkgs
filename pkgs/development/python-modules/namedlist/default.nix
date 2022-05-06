{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "namedlist";
  version = "1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NPifyZJZLICzmnCeE27c9B6hfyS6Mer4SjFKAsi5vO8=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Deprecation warning using collections.abc, https://gitlab.com/ericvsmith/namedlist/-/merge_requests/1
    (fetchpatch {
      url = "https://gitlab.com/ericvsmith/namedlist/-/commit/102d15b455e6f058b9c95fe135167be82b34c14a.patch";
      sha256 = "sha256-IfDgiObFFSOUnAlXR/+ye8uutGaFJ/AyQvCb76iNaMM=";
    })
  ];

  # Test file has a `unittest.main()` at the bottom that fails the tests;
  # py.test can run the tests without it.
  postPatch = ''
    substituteInPlace test/test_namedlist.py --replace "unittest.main()" ""
  '';

  pythonImportsCheck = [
    "namedlist"
  ];

  disabledTests = [
    # AttributeError: module 'collections' has no attribute 'Container'
    "test_ABC"
  ];

  meta = with lib; {
    description = "Similar to namedtuple, but instances are mutable";
    homepage = "https://gitlab.com/ericvsmith/namedlist";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan ];
  };
}
