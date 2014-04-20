{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.1.1";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "1783nb0b6nr9yjhb5wfh8ykc5w89f4anppz1kz9913mqg5vxdqi3";
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
