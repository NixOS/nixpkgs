{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.84";
  name = "libmediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "0k657ynfxcw6lvakc8plz0pzfixlqbsiih2idimk9k1dd4xzhq3d";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzen zlib ];

  sourceRoot = "./MediaInfoLib/Project/GNU/Library/";

  configureFlags = [ "--enable-shared" ];

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with stdenv.lib; {
    description = "Shared library for mediainfo";
    homepage = http://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
