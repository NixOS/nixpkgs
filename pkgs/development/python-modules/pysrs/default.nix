{ lib
, buildPythonPackage
, fetchPypi
, bsddb3
}:

buildPythonPackage rec {
  pname = "pysrs";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GmtjadY/rESlD3s2k4Ftm2xxYPCecLCyXs5XDJU1R9g=";
  };

  nativeBuildInputs = [ ];

  propagatedBuildInputs = [ bsddb3 ];

  preCheck = ''
    rm -v testd.py testSRS.py
  '';

  meta = with lib; {
    description = "Python SRS (Sender Rewriting Scheme) library";
    homepage = "https://pypi.org/project/pysrs/";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
