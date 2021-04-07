{ buildPythonPackage, fetchFromGitHub, lib, isPyPy
, pycrypto, ecdsa # TODO
, tox, mock, coverage, can, brotli
, withOptionalDeps ? true, tcpdump, ipython
, withCryptography ? true, cryptography
, withVoipSupport ? true, sox
, withPlottingSupport ? true, matplotlib
, withGraphicsSupport ? false, pyx, texlive, graphviz, imagemagick
, withManufDb ? false, wireshark
# 2D/3D graphics and graphs TODO: VPython
# TODO: nmap, numpy
}:

buildPythonPackage rec {
  pname = "scapy";
  version = "2.4.4";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "secdev";
    repo = "scapy";
    rev = "v${version}";
    sha256 = "1wpx7gps3g8q5ykbfcd67mxwcs416zg37b53fwfzzlc1m58vhk3p";
  };

  postPatch = ''
    printf "${version}" > scapy/VERSION
  '' + lib.optionalString withManufDb ''
    substituteInPlace scapy/data.py --replace "/opt/wireshark" "${wireshark}"
  '';

  propagatedBuildInputs = [ pycrypto ecdsa ]
    ++ lib.optionals withOptionalDeps [ tcpdump ipython ]
    ++ lib.optional withCryptography cryptography
    ++ lib.optional withVoipSupport sox
    ++ lib.optional withPlottingSupport matplotlib
    ++ lib.optionals withGraphicsSupport [ pyx texlive.combined.scheme-minimal graphviz imagemagick ];

  # Running the tests seems too complicated:
  doCheck = false;
  checkInputs = [ tox mock coverage can brotli ];
  checkPhase = ''
    patchShebangs .
    .config/ci/test.sh
  '';

  meta = with lib; {
    description = "A Python-based network packet manipulation program and library";
    longDescription = ''
      Scapy is a powerful Python-based interactive packet manipulation program
      and library.

      It is able to forge or decode packets of a wide number of protocols, send
      them on the wire, capture them, store or read them using pcap files,
      match requests and replies, and much more. It is designed to allow fast
      packet prototyping by using default values that work.

      It can easily handle most classical tasks like scanning, tracerouting,
      probing, unit tests, attacks or network discovery (it can replace hping,
      85% of nmap, arpspoof, arp-sk, arping, tcpdump, wireshark, p0f, etc.). It
      also performs very well at a lot of other specific tasks that most other
      tools can't handle, like sending invalid frames, injecting your own
      802.11 frames, combining techniques (VLAN hopping+ARP cache poisoning,
      VoIP decoding on WEP protected channel, ...), etc.

      Scapy supports Python 2.7 and Python 3 (3.4 to 3.8). It's intended to be
      cross platform, and runs on many different platforms (Linux, OSX, *BSD,
      and Windows).
    '';
    homepage = "https://scapy.net/";
    changelog = "https://github.com/secdev/scapy/releases/tag/v${version}";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos bjornfor ];
  };
}
