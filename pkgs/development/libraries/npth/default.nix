{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "npth-1.5";

  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/npth/${name}.tar.bz2";
    sha256 = "1hmkkp6vzyrh8v01c2ynzf9vwikyagp7p1lxhbnr4ysk3w66jji9";
  };

  doCheck = true;

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
