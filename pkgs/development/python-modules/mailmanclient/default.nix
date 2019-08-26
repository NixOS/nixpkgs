{ stdenv, buildPythonPackage, fetchPypi, six, httplib2 }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xsrzdrsmfhnxv68zwm1g6awk7in08k6yhkyd27ipn0mq1wjm5jd";
  };

  propagatedBuildInputs = [ six httplib2 ];
}
