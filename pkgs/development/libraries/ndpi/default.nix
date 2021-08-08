{ lib, stdenv, fetchFromGitHub, which, autoconf, automake, libtool, libpcap
, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ndpi";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = version;
    sha256 = "0xjh9gv0mq0213bjfs5ahrh6m7l7g99jjg8104c0pw54hz0p5pq1";
  };

  configureScript = "./autogen.sh";

  nativeBuildInputs = [which autoconf automake libtool];
  buildInputs = [
    libpcap
    pkg-config
  ];

  meta = with lib; {
    description = "A library for deep-packet inspection";
    longDescription = ''
      nDPI is a library for deep-packet inspection based on OpenDPI.
    '';
    homepage = "https://www.ntop.org/products/deep-packet-inspection/ndpi/";
    license = with licenses; lgpl3;
    maintainers = with maintainers; [ takikawa ];
    platforms = with platforms; unix;
  };
}
