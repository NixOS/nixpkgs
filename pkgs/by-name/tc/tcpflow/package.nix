{
  stdenv,
  lib,
  fetchFromGitHub,
  automake,
  autoconf,
  openssl,
  zlib,
  libpcap,
  boost,
  useCairo ? false,
  cairo,
}:

stdenv.mkDerivation rec {
  pname = "tcpflow";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0vbm097jhi5n8pg08ia1yhzc225zv9948blb76f4br739l9l22vq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];
  buildInputs = [
    openssl
    zlib
    libpcap
    boost
  ] ++ lib.optional useCairo cairo;

  prePatch = ''
    substituteInPlace bootstrap.sh \
      --replace ".git" "" \
      --replace "/bin/rm" "rm"
    # Temporary fix for a build error:
    # https://src.fedoraproject.org/rpms/tcpflow/blob/979e250032b90de2d6b9e5b94b5203d98cccedad/f/tcpflow-1.6.1-format.patch
    substituteInPlace src/datalink.cpp \
      --replace 'DEBUG(6)(s.c_str());' 'DEBUG(6) ("%s", s.c_str());'
  '';

  preConfigure = "bash ./bootstrap.sh";

  meta = with lib; {
    description = "TCP stream extractor";
    longDescription = ''
      tcpflow is a program that captures data transmitted as part of TCP
      connections (flows), and stores the data in a way that is convenient for
      protocol analysis and debugging.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      raskin
      obadz
    ];
    platforms = platforms.unix;
    mainProgram = "tcpflow";
  };
}
