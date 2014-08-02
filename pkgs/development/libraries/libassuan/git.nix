{ fetchgit, stdenv, pth, libgpgerror, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libassuan-2.1pre-git20120407";

  src = fetchgit {
    url = "git://git.gnupg.org/libassuan.git";
    rev = "5c00c7cc2901a879927a5756e1bb7ecf49439ebc";
    sha256 = "14ebcc65930360a067eea8cfbdaa5418c909bd9dfb27fe366edf78ad6c1aa69f";
  };

  propagatedBuildInputs = [ pth libgpgerror ];
  buildInputs = [ autoconf automake libtool ];

  doCheck = true;

  preConfigure = "autoreconf -v";

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
    platforms = stdenv.lib.platforms.all;
  };
}
