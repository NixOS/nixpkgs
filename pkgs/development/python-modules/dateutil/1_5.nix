{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six }:

buildPythonPackage rec {
  pname = "python-dateutil";
  version = "1.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02dhw57jf5kjcp7ng1if7vdrbnlpb9yjmz7wygwwvf3gni4766bg";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
