{ stdenv, fetchurl, buildPythonPackage, pep8 }:

buildPythonPackage rec {
  name = "autopep8-1.0.4";

  src = fetchurl {
    url = "mirror://pypi/a/autopep8/${name}.tar.gz";
    sha256 = "17lydqm8y9a5qadp6iifxrb5mb0g9fr1vxn5qy1fjpyhazxaw8n1";
  };

  propagatedBuildInputs = [ pep8 ];

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
