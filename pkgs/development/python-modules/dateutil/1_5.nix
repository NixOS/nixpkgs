{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six }:

buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.7.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
