{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.23.0";
  name = "cmark-${version}";

  src = fetchurl {
    url = "https://github.com/jgm/cmark/archive/${version}.tar.gz";
    sha256 = "87d289965066fce7be247d44c0304af1b20817dcc1b563702302ae33f2be0596";
  };

  buildInputs = [ cmake ];

  meta = {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = https://github.com/jgm/cmark;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = stdenv.lib.platforms.unix;
  };
}
