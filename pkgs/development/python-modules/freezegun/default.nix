{ stdenv
, buildPythonPackage
, fetchPypi
, dateutil
, six
, mock
, nose
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sf38d3ibv1jhhvr52x7dhrsiyqk1hm165dfv8w8wh0fhmgxg151";
  };

  propagatedBuildInputs = [ dateutil six ];
  buildInputs = [ mock nose ];

  meta = with stdenv.lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
