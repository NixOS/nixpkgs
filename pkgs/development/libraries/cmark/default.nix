{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "0.27.1";
  name = "cmark-${version}";

  src = fetchurl {
    url = "https://github.com/jgm/cmark/archive/${version}.tar.gz";
    sha256 = "1da62ispca9aal2a36gaj87175rv5013pl7x740vk32y6lclr6v6";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = https://github.com/jgm/cmark;
    maintainers = [ stdenv.lib.maintainers.michelk ];
    platforms = stdenv.lib.platforms.unix;
  };
}
