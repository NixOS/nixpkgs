{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "2.0.5";
  pname = "pydispatcher";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bswbmhlbqdxlgbxlb6xrlm4k253sg8nvpl1whgsys8p3fg0cw2m";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://pydispatcher.sourceforge.net/;
    description = "Signal-registration and routing infrastructure for use in multiple contexts";
    license = licenses.bsd3;
  };

}
