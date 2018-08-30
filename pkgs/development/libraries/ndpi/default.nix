{ stdenv, fetchFromGitHub, which, autoconf, automake, libtool, libpcap }:

let version = "2.2"; in

stdenv.mkDerivation rec {
  name = "ndpi-${version}";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "nDPI";
    rev = "${version}";
    sha256 = "06gg8lhn944arlczmv5i40jkjdnl1nrvsmvm843l9ybcswpayv4m";
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
