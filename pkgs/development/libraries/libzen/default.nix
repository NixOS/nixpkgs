{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.37";
  pname = "libzen";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "1hcsrmn85b0xp0mp33aazk7g071q1v3f163nnhv8b0mv9c4bgsfn";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = https://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
