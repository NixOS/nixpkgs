{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "4.5.0";
  pname = "pyfakefs";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58b017b3437bbe97803a23755876c6d6aeb5aea37e52cec15e5d86b59c4c7295";
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

  checkInputs = [ pytestCheckHook ];
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
