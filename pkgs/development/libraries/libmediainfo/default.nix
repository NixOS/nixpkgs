{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "19.07";
  name = "libmediainfo-${version}";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "0k3d7mha1lay2s09crc9z9zr970l617lb0c3b35wl44flkqf7jss";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzen zlib ];

  sourceRoot = "./MediaInfoLib/Project/GNU/Library/";

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with stdenv.lib; {
    description = "Shared library for mediainfo";
    homepage = https://mediaarea.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
