{ stdenv, buildPythonPackage, fetchPypi, python, pytest, glibcLocales, isPy37 }:

buildPythonPackage rec {
  version = "3.7.2";
  pname = "pyfakefs";

  src = fetchPypi {
    inherit pname version;
    sha256 = "735ce6a71f26ead335df8a1f2c1cc8355ef091d98ffdc3bf73a5a3b0214e055e";
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

  # https://github.com/jmcgeheeiv/pyfakefs/issues/508
  doCheck = !isPy37;
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
    maintainers = with maintainers; [ gebner ];
  };
}
