{ stdenv, buildPythonPackage, fetchFromGitHub, python, pytest, glibcLocales }:

buildPythonPackage rec {
  version = "3.4.1";
  pname = "pyfakefs";

  # no tests in PyPI tarball
  # https://github.com/jmcgeheeiv/pyfakefs/pull/361
  src = fetchFromGitHub {
    owner = "jmcgeheeiv";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i8kq7sl8bczr927hllgfhsmirjqjh89c9184kcqmprc13ac4kxy";
  };

  postPatch = ''
    # test doesn't work in sandbox
    substituteInPlace tests/fake_filesystem_test.py \
      --replace "test_expand_root" "notest_expand_root"
    substituteInPlace tests/fake_os_test.py \
      --replace "test_append_mode" "notest_append_mode"
  '';

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 ${python.interpreter} -m tests.all_tests
    py.test tests/pytest_plugin_test.py
  '';

  meta = with stdenv.lib; {
    description = "Fake file system that mocks the Python file system modules";
    license     = licenses.asl20;
    homepage    = http://pyfakefs.org/;
    maintainers = with maintainers; [ gebner ];
  };
}
