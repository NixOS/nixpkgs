{ lib
, buildPythonPackage
, fetchPypi
, nose
, pygments
, isPy3k
}:

buildPythonPackage rec {
  version = "0.9.2";
  pname = "piep";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5anpsq16xkiisws95jif5s5mplkl1kdnhy0w0i6m0zcy50jnxq";
  };

  propagatedBuildInputs = [ pygments ];
  checkInputs = [ nose ];

  meta = with lib; {
    description = "Bringing the power of python to stream editing";
    homepage = "https://github.com/timbertson/piep";
    maintainers = with maintainers; [ timbertson ];
    license = licenses.gpl3;
  };

}
