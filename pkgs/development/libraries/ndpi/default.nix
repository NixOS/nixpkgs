{ stdenv, fetchFromGitHub, which, autoconf, automake, libtool, libpcap }:

let version = "2.8"; in

stdenv.mkDerivation rec {
  name = "ndpi-${version}";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = "${version}";
    sha256 = "0lc4vga89pm954vf92g9fa6xwsjkb13jd6wrcc35zy5j04nf9rzf";
  };

  configureScript = "./autogen.sh";

  nativeBuildInputs = [which autoconf automake libtool];
  buildInputs = [libpcap];

  meta = with stdenv.lib; {
    description = "A library for deep-packet inspection";
    longDescription = ''
      nDPI is a library for deep-packet inspection based on OpenDPI.
    '';
    homepage = https://www.ntop.org/products/deep-packet-inspection/ndpi/;
    license = with licenses; lgpl3;
    maintainers = with maintainers; [ takikawa ];
    platforms = with platforms; unix;
  };
}
