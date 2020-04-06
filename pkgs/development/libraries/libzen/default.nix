{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.38";
  pname = "libzen";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "1nkygc17sndznpcf71fdrhwpm8z9a3hc9csqlafwswh49axhfkjr";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
