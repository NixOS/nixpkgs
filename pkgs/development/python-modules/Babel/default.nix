{ stdenv, fetchPypi, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "050zyi300wsyqq1cj0ajrskb5kkv0wxblz124g9yv4s3vmpwpr4c";
  };

  buildInputs = with pythonPackages; [ pytest freezegun ];
  propagatedBuildInputs = with pythonPackages; [ pytz ];

  meta = with stdenv.lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = [ garbas ];
  };
}

