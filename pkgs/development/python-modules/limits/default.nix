{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dfbrmqixsvhvzqgd4s8rfj933k1w5q4bm23pp9zyp70xlb0mfmd";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with stdenv.lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = https://limits.readthedocs.org/;
  };
}
