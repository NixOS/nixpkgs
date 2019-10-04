{ stdenv, lib, darwin, fetchurl, pkgconfig, makeWrapper, SDL2 }:

stdenv.mkDerivation rec {
  name = "smpeg2-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/smpeg/release/${name}.tar.gz";
    sha256 = "1cwlakc4qk1wzsx7drrsf3zi4jp6ci6nx6qsckx48jkl26r6b6lp";
  };

  patches = [
    ./gcc6.patch
  ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ SDL2 ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc;

  postInstall = ''
    wrapProgram $out/bin/smpeg2-config \
      --prefix PATH ":" "${pkgconfig}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${SDL2.dev}/lib/pkgconfig"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://icculus.org/smpeg/;
    description = "SDL2 MPEG Player Library";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
