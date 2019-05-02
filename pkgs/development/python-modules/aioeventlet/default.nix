{ stdenv
, buildPythonPackage
, fetchPypi
, eventlet
, trollius
, mock
, python
}:

buildPythonPackage rec {
  pname = "aioeventlet";
  # version is called 0.5.1 on PyPI, but the filename is aioeventlet-0.5.2.tar.gz
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cecb51ea220209e33b53cfb95124d90e4fcbee3ff8ba8a179a57120b8624b16a";
  };

  propagatedBuildInputs = [ eventlet trollius ];
  buildInputs = [ mock ];

  # 2 tests error out
  doCheck = false;
  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with stdenv.lib; {
    description = "aioeventlet implements the asyncio API (PEP 3156) on top of eventlet. It makes";
    homepage = https://aioeventlet.readthedocs.org/;
    license = licenses.asl20;
  };

}
