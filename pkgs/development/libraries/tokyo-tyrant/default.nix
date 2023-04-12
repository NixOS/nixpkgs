{ fetchurl, lib, stdenv, tokyocabinet, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tokyotyrant";
  version = "1.1.41";

  src = fetchurl {
    url = "https://fallabs.com/tokyotyrant/tokyotyrant-${version}.tar.gz";
    sha256 = "13xqcinhydqmh7231qlir6pymacjwcf98drybkhd9597kzxp1bs2";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ tokyocabinet ];

  doCheck = false; # FIXME

  meta = {
    description = "Network interface of the Tokyo Cabinet DBM";

    longDescription =
      '' Tokyo Tyrant is a package of network interface to the DBM called
         Tokyo Cabinet.  Though the DBM has high performance, you might
         bother in case that multiple processes share the same database, or
         remote processes access the database.  Thus, Tokyo Tyrant is
         provided for concurrent and remote connections to Tokyo Cabinet.  It
         is composed of the server process managing a database and its access
         library for client applications.

         Tokyo Tyrant is written in the C language, and provided as API of C,
         Perl, and Ruby.  Tokyo Tyrant is available on platforms which have
         API conforming to C99 and POSIX.  Tokyo Tyrant is a free software
         licensed under the GNU Lesser General Public License.
       '';

    homepage = "https://fallabs.com/tokyotyrant/";

    license = lib.licenses.lgpl21Plus;

    platforms = lib.platforms.gnu ++ lib.platforms.linux; # arbitrary choice
    maintainers = [ ];
  };
}
