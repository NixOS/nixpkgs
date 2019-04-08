{ fetchurl, stdenv, gettext, pth, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libassuan-2.5.2";

  src = fetchurl {
    url = "mirror://gnupg/libassuan/${name}.tar.bz2";
    sha256 = "1rw8nw6fx6ppxga6m4cqcp898lnlzf7vn3s5c2lzfxg3fzr1nswq";
  };

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # libassuan-config

  buildInputs = [ libgpgerror pth gettext];

  doCheck = true;

  # Make sure includes are fixed for callers who don't use libassuan-config
  postInstall = ''
    sed -i 's,#include <gpg-error.h>,#include "${libgpgerror.dev}/include/gpg-error.h",g' $dev/include/assuan.h
  '';

  meta = with stdenv.lib; {
    description = "IPC library used by GnuPG and related software";
    longDescription = ''
      Libassuan is a small library implementing the so-called Assuan
      protocol.  This protocol is used for IPC between most newer
      GnuPG components.  Both, server and client side functions are
      provided.
    '';
    homepage = http://gnupg.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
