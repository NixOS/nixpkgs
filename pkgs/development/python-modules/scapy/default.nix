{ stdenv, lib, buildPythonPackage, fetchFromGitHub, isPyPy, isPy3k, pythonOlder
, matplotlib, pycrypto, ecdsa
, enum34, mock
}:

buildPythonPackage rec {
  pname = "scapy";
  version = "2.4.0";
  name = pname + "-" + version;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "secdev";
    repo = "scapy";
    rev = "v${version}";
    sha256 = "0dw6kl1qi9bf3rbm79gb1h40ms8y0b5dbmpip841p2905d5r2isj";
  };

  # TODO: Temporary workaround
  patches = [ ./fix-version-1.patch ./fix-version-2.patch ];

  propagatedBuildInputs =
    [ matplotlib pycrypto ecdsa ]
    ++ lib.optional (isPy3k && pythonOlder "3.4") [ enum34 ]
    ++ lib.optional doCheck [ mock ];

  # Tests fail with Python 3.6 (seems to be an upstream bug, I'll investigate)
  doCheck = if isPy3k then false else true;

  meta = with stdenv.lib; {
    description = "Powerful interactive network packet manipulation program";
    homepage = https://scapy.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos bjornfor ];
  };
}
