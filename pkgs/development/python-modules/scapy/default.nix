{
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  lib,
  isPyPy,
  pycrypto,
  ecdsa, # TODO
  mock,
  python-can,
  brotli,
  withOptionalDeps ? true,
  tcpdump,
  ipython,
  withCryptography ? true,
  cryptography,
  withVoipSupport ? true,
  sox,
  withPlottingSupport ? true,
  matplotlib,
  withGraphicsSupport ? false,
  pyx,
  texliveBasic,
  graphviz,
  imagemagick,
  withManufDb ? false,
  wireshark,
  libpcap,
# 2D/3D graphics and graphs TODO: VPython
# TODO: nmap, numpy
}:

buildPythonPackage rec {
  pname = "scapy";
  version = "2.5.0";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "secdev";
    repo = "scapy";
    rev = "v${version}";
    hash = "sha256-xJlovcxUQOQHfOU0Jgin/ayd2T5fOyeN4Jg0DbLHoeU=";
  };

  patches = [ ./find-library.patch ];

  postPatch =
    ''
      printf "${version}" > scapy/VERSION

      libpcap_file="${lib.getLib libpcap}/lib/libpcap${stdenv.hostPlatform.extensions.sharedLibrary}"
      if ! [ -e "$libpcap_file" ]; then
          echo "error: $libpcap_file not found" >&2
          exit 1
      fi
      substituteInPlace "scapy/libs/winpcapy.py" \
          --replace "@libpcap_file@" "$libpcap_file"
    ''
    + lib.optionalString withManufDb ''
      substituteInPlace scapy/data.py --replace "/opt/wireshark" "${wireshark}"
    '';

  buildInputs = lib.optional withVoipSupport sox;

  propagatedBuildInputs =
    [
      pycrypto
      ecdsa
    ]
    ++ lib.optionals withOptionalDeps [
      tcpdump
      ipython
    ]
    ++ lib.optional withCryptography cryptography
    ++ lib.optional withPlottingSupport matplotlib
    ++ lib.optionals withGraphicsSupport [
      pyx
      texliveBasic
      graphviz
      imagemagick
    ];

  # Running the tests seems too complicated:
  doCheck = false;
  nativeCheckInputs = [
    mock
    python-can
    brotli
  ];
  checkPhase = ''
    # TODO: be more specific about files
    patchShebangs .
    .config/ci/test.sh
  '';
  pythonImportsCheck = [ "scapy" ];

  meta = with lib; {
    description = "Python-based network packet manipulation program and library";
    mainProgram = "scapy";
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
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      primeos
      bjornfor
    ];
  };
}
