{ stdenv, fetchgit, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "npth-git20120407";

  src = fetchgit {
    url = "git://git.gnupg.org/npth.git";
    rev = "cbb52bd5ada02bbd914869f4540221831358d077";
    sha256 = "1789b15bc49171d47bbd5a3bccbadc7dde1ae095bb2c205c7ec5d7a36573876d";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = "autoreconf -vfi";

  meta = {
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
    license = "LGPLv3";
    platforms = stdenv.lib.platforms.all;
  };
}
