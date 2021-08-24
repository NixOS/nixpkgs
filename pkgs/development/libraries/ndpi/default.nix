{ lib, stdenv, fetchFromGitHub, which, autoconf, automake, libtool, libpcap
, pkg-config }:

let version = "3.4"; in

stdenv.mkDerivation {
  pname = "ndpi";
  inherit version;

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = version;
    sha256 = "0xjh9gv0mq0213bjfs5ahrh6m7l7g99jjg8104c0pw54hz0p5pq1";
  };

  patches = [
    ./3.4-CVE-2021-36082.patch
  ];

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
