{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "crccheck";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0ckymm6s5kw08i1j35fy2cfha1hyq94pq1kc66brb552qgjs91jn";
  };

  propagatedBuildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Calculation library for CRCs and checksums";
    homepage = https://bitbucket.org/martin_scharrer/crccheck;
    maintainers = with maintainers; [ elseym ];
  };
}
