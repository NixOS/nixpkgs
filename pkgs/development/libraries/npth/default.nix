{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "npth-1.1";

  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/npth/${name}.tar.bz2";
    sha256 = "0zyzwmk4mp6pas87jz35zx0jvwdz7x5b13w225gs73gcn8g5cv49";
  };

  meta = with stdenv.lib; {
    description = "The New GNU Portable Threads Library";
    longDescription = ''
      This is a library to provide the GNU Pth API and thus a non-preemptive
      threads implementation.

      In contrast to GNU Pth is is based on the system's standard threads
      implementation.  This allows the use of libraries which are not
      compatible to GNU Pth.  Experience with a Windows Pth emulation showed
      that this is a solid way to provide a co-routine based framework.
    '';
    homepage = http://www.gnupg.org;
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
