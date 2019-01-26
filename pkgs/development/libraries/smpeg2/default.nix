{ stdenv, darwin, fetchsvn, autoconf, automake, pkgconfig, makeWrapper, SDL2 }:

stdenv.mkDerivation rec {
  name = "smpeg2-svn${version}";
  version = "412";

  src = fetchsvn {
    url = svn://svn.icculus.org/smpeg/trunk;
    rev = version;
    sha256 = "1irf2d8f150j8cx8lbb0pz1rijap536crsz0mw871xrh6wd2fd96";
  };

  patches = [
    ./gcc6.patch
    ./sdl2.patch
  ];

  nativeBuildInputs = [ autoconf automake pkgconfig makeWrapper ];

  buildInputs = [ SDL2 ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.libobjc;

  preConfigure = ''
    sh autogen.sh
  '';

  postInstall = ''
    sed -e 's,#include "\(SDL.*.h\)",#include <SDL2/\1>,' -i $out/include/smpeg2/*.h

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
