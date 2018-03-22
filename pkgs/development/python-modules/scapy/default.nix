{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, isPyPy
, matplotlib, pycrypto, ecdsa
# Python3: pyx
}:

buildPythonPackage rec {
  pname = "scapy";
  version = "2.3.3";
  name = pname + "-" + version;

  disabled = isPy3k || isPyPy;

  src = fetchFromGitHub {
    owner = "secdev";
    repo = "scapy";
    rev = "v${version}";
    sha256 = "1c22407vhksnhc0rwrslnp9zy05qmk2zmdm2imm3iw7g6kx7gak1";
  };

  # Temporary workaround, only needed for 2.3.3
  patches = [ ./fix-version-1.patch ./fix-version-2.patch ];

  propagatedBuildInputs = [ matplotlib pycrypto ecdsa ];

  meta = with stdenv.lib; {
    description = "Powerful interactive network packet manipulation program";
    homepage = http://www.secdev.org/projects/scapy/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos bjornfor ];
  };
}
