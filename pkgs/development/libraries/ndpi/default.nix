{ stdenv, fetchFromGitHub, which, autoconf, automake, libtool, libpcap }:

let version = "1.8"; in

stdenv.mkDerivation rec {
  name = "ndpi-${version}";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = "${version}";
    sha256 = "0kxp9dv4d1nmr2cxv6zsfy2j14wyb0q6am0qyxg0npjb08p7njf4";
  };

  configureScript = "./autogen.sh";

  nativeBuildInputs = [which autoconf automake libtool];
  buildInputs = [libpcap];

  meta = with stdenv.lib; {
    description = "A library for deep-packet inspection";
    longDescription = ''
      nDPI is a library for deep-packet inspection based on OpenDPI.
    '';
    homepage = http://www.ntop.org/products/deep-packet-inspection/ndpi/;
    license = with licenses; lgpl3;
    maintainers = with maintainers; [ takikawa ];
    platforms = with platforms; unix;
  };
}
