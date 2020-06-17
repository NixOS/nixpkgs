{ stdenv, buildPythonPackage, fetchPypi
, nose }:

buildPythonPackage rec {
  pname = "crccheck";
  version = "0.6";

  buildInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ckymm6s5kw08i1j35fy2cfha1hyq94pq1kc66brb552qgjs91jn";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://bitbucket.org/martin_scharrer/crccheck";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
