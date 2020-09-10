{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, python, pytest, glibcLocales }:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "pyfakefs";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbbaa8b622fa50751a5839350fff3c1f8b1bbd364cd40fd0c7442e18fe5edc8e";
  };

  postPatch = ''
    # test doesn't work in sandbox
    substituteInPlace pyfakefs/tests/fake_filesystem_test.py \
      --replace "test_expand_root" "notest_expand_root"
    substituteInPlace pyfakefs/tests/fake_os_test.py \
      --replace "test_path_links_not_resolved" "notest_path_links_not_resolved" \
      --replace "test_append_mode_tell_linux_windows" "notest_append_mode_tell_linux_windows"
    substituteInPlace pyfakefs/tests/fake_filesystem_unittest_test.py \
      --replace "test_copy_real_file" "notest_copy_real_file"
  '' + (stdenv.lib.optionalString stdenv.isDarwin ''
    # this test fails on darwin due to case-insensitive file system
    substituteInPlace pyfakefs/tests/fake_os_test.py \
      --replace "test_rename_dir_to_existing_dir" "notest_rename_dir_to_existing_dir"
  '');

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    ${python.interpreter} -m pyfakefs.tests.all_tests
    ${python.interpreter} -m pyfakefs.tests.all_tests_without_extra_packages
    ${python.interpreter} -m pytest pyfakefs/pytest_tests/pytest_plugin_test.py
  '';

  meta = with stdenv.lib; {
    description = "Fake file system that mocks the Python file system modules";
    license     = licenses.asl20;
    homepage    = "http://pyfakefs.org/";
    changelog   = "https://github.com/jmcgeheeiv/pyfakefs/blob/master/CHANGES.md";
    maintainers = with maintainers; [ gebner ];
  };
}
