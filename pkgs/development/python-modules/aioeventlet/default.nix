{ stdenv
, buildPythonPackage
, fetchPypi
, eventlet
, trollius
, asyncio
, mock
, python
}:

buildPythonPackage rec {
  pname = "aioeventlet";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19krvycaiximchhv1hcfhz81249m3w3jrbp2h4apn1yf4yrc4y7y";
  };

  propagatedBuildInputs = [ eventlet trollius asyncio ];
  buildInputs = [ mock ];

  # 2 tests error out
  doCheck = false;
  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with stdenv.lib; {
    description = "aioeventlet implements the asyncio API (PEP 3156) on top of eventlet. It makes";
    homepage = http://aioeventlet.readthedocs.org/;
    license = licenses.asl20;
  };

}
