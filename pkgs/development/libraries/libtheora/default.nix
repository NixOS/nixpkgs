{lib, stdenv, fetchurl, libogg, libvorbis, pkg-config, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libtheora-1.1.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/theora/${name}.tar.gz";
    sha256 = "0swiaj8987n995rc7hw0asvpwhhzpjiws8kr3s6r44bqqib2k5a0";
  };

  patches = [
    # fix error in autoconf scripts
    (fetchpatch {
      url = "https://github.com/xiph/theora/commit/28cc6dbd9b2a141df94f60993256a5fca368fa54.diff";
      sha256 = "16jqrq4h1b3krj609vbpzd5845cvkbh3mwmjrcdg35m490p19x9k";
    })
  ];

  outputs = [ "out" "dev" "devdoc" ];
  outputDoc = "devdoc";

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  propagatedBuildInputs = [ libogg libvorbis ];

  meta = with lib; {
    homepage = "https://www.theora.org/";
    description = "Library for Theora, a free and open video compression format";
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
