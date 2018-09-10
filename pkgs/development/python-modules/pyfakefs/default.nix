{ stdenv, buildPythonPackage, fetchFromGitHub, python, pytest, glibcLocales }:

buildPythonPackage rec {
  version = "3.4.3";
  pname = "pyfakefs";

  # no tests in PyPI tarball
  # https://github.com/jmcgeheeiv/pyfakefs/pull/361
  src = fetchFromGitHub {
    owner = "jmcgeheeiv";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rhbkcb5h2x8kmyxivr5jr1db2xvmpjdbsfjxl142qhfb29hr2hp";
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
    ${python.interpreter} -m pytest pyfakefs/tests/pytest_plugin_test.py
  '';

  meta = with stdenv.lib; {
    description = "Fake file system that mocks the Python file system modules";
    license     = licenses.asl20;
    homepage    = http://pyfakefs.org/;
    maintainers = with maintainers; [ gebner ];
  };
}
