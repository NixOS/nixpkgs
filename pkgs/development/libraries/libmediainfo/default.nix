{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "21.03";
  pname = "libmediainfo";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "1jm4mk539wf3crgpcddgwdixshwdzm37mkb5441lifhcz2mykdsn";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libzen zlib ];

  sourceRoot = "./MediaInfoLib/Project/GNU/Library/";

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
