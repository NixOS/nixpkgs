{ stdenv, fetchurl, autoreconfHook, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "19.09";
  pname = "libmediainfo";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "13j7by2czapzi6qznxj4nmn3hwiyglcf2ypja4n6zgnz96jf21pz";
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
