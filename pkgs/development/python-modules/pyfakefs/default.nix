{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # tests
  pandas,
  pytestCheckHook,
  undefined,
}:

buildPythonPackage rec {
  pname = "pyfakefs";
  version = "5.5.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dEiqoHFC+JLQpOtSpe0yBqnwLGWZ5obNl9YkwYl5wVQ=";
  };

  postPatch =
    ''
      # test doesn't work in sandbox
      substituteInPlace pyfakefs/tests/fake_filesystem_test.py \
        --replace "test_expand_root" "notest_expand_root"
      substituteInPlace pyfakefs/tests/fake_os_test.py \
        --replace "test_path_links_not_resolved" "notest_path_links_not_resolved" \
        --replace "test_append_mode_tell_linux_windows" "notest_append_mode_tell_linux_windows"
    ''
    + (lib.optionalString stdenv.isDarwin ''
      # this test fails on darwin due to case-insensitive file system
      substituteInPlace pyfakefs/tests/fake_os_test.py \
        --replace "test_rename_dir_to_existing_dir" "notest_rename_dir_to_existing_dir"
    '');

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyfakefs" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
    undefined
  ];

  meta = with lib; {
    description = "Fake file system that mocks the Python file system modules";
    homepage = "http://pyfakefs.org/";
    changelog = "https://github.com/jmcgeheeiv/pyfakefs/blob/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
