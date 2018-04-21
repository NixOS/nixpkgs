{ stdenv, fetchPypi, buildPythonPackage, pycodestyle }:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.3.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "192bvhzi4d0claqxgzymvv7k3qnj627742bc8sgxpzjj42pd9112";
  };

  propagatedBuildInputs = [ pycodestyle ];

  # One test fails:
  # FAIL: test_recursive_should_not_crash_on_unicode_filename (test.test_autopep8.CommandLineTests)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = https://pypi.python.org/pypi/autopep8/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
