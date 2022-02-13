{ lib
, stdenv
, fetchFromGitHub
, which
, autoconf
, automake
, libtool
, libpcap
, json_c
, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ndpi";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = version;
    sha256 = "0snzvlracc6s7r2pgdn0jqcc7nxjxzcivsa579h90g5ibhhplv5x";
  };

  configureScript = "./autogen.sh";

  nativeBuildInputs = [ which autoconf automake libtool pkg-config ];
  buildInputs = [
    libpcap
    json_c
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
