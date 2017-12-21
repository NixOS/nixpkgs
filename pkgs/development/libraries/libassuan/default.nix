{ fetchurl, stdenv, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.5.1";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "0jb4nb4nrjr949gd3lw8lh4v5d6qigxaq6xwy24w5apjnhvnrya7";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # libassuan-config

  buildInputs = [ libgpgerror pth ];

  doCheck = true;

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' $dev/include/assuan.h
  '';

  meta = {
    description = "IPC library used by GnuPG and related software";

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
