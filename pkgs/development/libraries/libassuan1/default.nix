{ fetchurl, stdenv, pth }:

stdenv.mkDerivation rec {
  name = "libassuan-1.0.5";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "1xar8i5jmah75wa9my4x7vkc5b6nmzd2p6k9kmpdg9hsv04292y5";
  };

  propagatedBuildInputs = [ pth ];

  doCheck = true;

  meta = {
    description = "Libassuan, the IPC library used by GnuPG and related software";

    longDescription = ''
      Libassuan is a small library implementing the so-called Assuan
      protocol.  This protocol is used for IPC between most newer
      GnuPG components.  Both, server and client side functions are
      provided.
    '';

    homepage = http://gnupg.org;
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
