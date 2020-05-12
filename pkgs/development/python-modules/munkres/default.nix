{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, nose
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "81e9ced40c3d0ffc48be4b6da5cfdfaa49041faaaba8075b159974ec47926aea";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = "http://bmc.github.com/munkres/";
    description = "Munkres algorithm for the Assignment Problem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
