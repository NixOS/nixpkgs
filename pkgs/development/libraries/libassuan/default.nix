{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.0.3";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "06xckkvxxlx7cj77803m8x58gxksap4k8yhspc5cqsy7fhinimds";
  };

  propagatedBuildInputs = [ libgpgerror pth ];

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
    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.all;
  };
}
