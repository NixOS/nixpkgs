{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "5.1.0";
  pname = "pyfakefs";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MWxgJmQNFKa0+95x/ZZ0V20bVxDe2o+r3oqtUdeF28M=";
  };

  postPatch = ''
    # test doesn't work in sandbox
    substituteInPlace pyfakefs/tests/fake_filesystem_test.py \
      --replace "test_expand_root" "notest_expand_root"
    substituteInPlace pyfakefs/tests/fake_os_test.py \
      --replace "test_path_links_not_resolved" "notest_path_links_not_resolved" \
      --replace "test_append_mode_tell_linux_windows" "notest_append_mode_tell_linux_windows"
  '' + (lib.optionalString stdenv.isDarwin ''
    # this test fails on darwin due to case-insensitive file system
    substituteInPlace pyfakefs/tests/fake_os_test.py \
      --replace "test_rename_dir_to_existing_dir" "notest_rename_dir_to_existing_dir"
  '');

  nativeCheckInputs = [ pytestCheckHook ];
  # https://github.com/jmcgeheeiv/pyfakefs/issues/581 (OSError: [Errno 9] Bad file descriptor)
  disabledTests = [ "test_open_existing_pipe" ];
  pythonImportsCheck = [ "pyfakefs" ];

  meta = with lib; {
    description = "Fake file system that mocks the Python file system modules";
    homepage = "http://pyfakefs.org/";
    changelog = "https://github.com/jmcgeheeiv/pyfakefs/blob/master/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gebner ];
  };
}
