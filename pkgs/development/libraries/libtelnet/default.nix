{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  name = "libtelnet-${version}";
  version = "0.21+45f2d5c";

  src = fetchFromGitHub {
    owner = "seanmiddleditch";
    repo = "libtelnet";
    rev = "45f2d5cfcf383312280e61c85b107285fed260cf";
    sha256 = "1lp6gdbndsp2w8mhy88c2jknxj2klvnggvq04ln7qjg8407ifpda";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ zlib ];

  meta = {
    description = "Simple RFC-complient TELNET implementation as a C library";
    homepage = "https://github.com/seanmiddleditch/libtelnet";
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [ stdenv.lib.maintainers.tomberek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
