{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.35";
  name = "libzen-${version}";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "12a1icgcffgv503ii2k1453kxg5hfly09mf4zjcc80aq8a6rf8by";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  meta = with stdenv.lib; {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = https://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
