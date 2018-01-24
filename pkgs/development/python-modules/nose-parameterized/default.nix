{ stdenv, fetchPypi, buildPythonPackage, nose, six, glibcLocales, isPy3k }:

buildPythonPackage rec {
  pname = "nose-parameterized";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khlabgib4161vn6alxsjaa8javriywgx9vydddi659gp9x6fpnk";
  };

  # Tests require some python3-isms but code works without.
  doCheck = isPy3k;

  buildInputs = [ nose glibcLocales ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -v
  '';

  meta = with stdenv.lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = https://pypi.python.org/pypi/nose-parameterized;
    license = licenses.bsd3;
  };
}
