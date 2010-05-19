{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.0.0";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "13vzs4jxscnlskwzd3wpqwnfb5f0hwqc75rbi8j9f42bs6q08apx";
  };

  propagatedBuildInputs = [ pth libgpgerror ];

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
  };
}
