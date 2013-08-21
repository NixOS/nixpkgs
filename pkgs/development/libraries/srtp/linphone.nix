{ stdenv, fetchgit, automake, autoconf, libtool }:

stdenv.mkDerivation {
  name = "srtp-linphone-git-20130530-1c9bd9065";

  src = fetchgit {
    url = git://git.linphone.org/srtp.git;
    rev = "1c9bd9065";
    sha256 = "0r4wbrih8bggs69fnfmzm17z1pp1zp8x9qwcckcq6wc54b16d9g3";
  };

  preConfigure = "autoreconf -vfi";

  buildInputs = [ automake autoconf libtool ];
}
