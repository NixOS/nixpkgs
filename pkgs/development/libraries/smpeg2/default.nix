{ lib, stdenv
, autoconf
, automake
, darwin
, fetchsvn
, makeWrapper
, pkg-config
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "smpeg2";
  version = "unstable-2017-10-18";

  src = fetchsvn {
    url = "svn://svn.icculus.org/smpeg/trunk";
    rev = "413";
    sha256 = "193amdwgxkb1zp7pgr72fvrdhcg3ly72qpixfxxm85rzz8g2kr77";
  };

  patches = [
    ./hufftable-uint_max.patch
  ];

  nativeBuildInputs = [ autoconf automake makeWrapper pkg-config ];

  buildInputs = [ SDL2 ]
    ++ lib.optional stdenv.isDarwin darwin.libobjc;

  preConfigure = ''
    sh autogen.sh
  '';

  postInstall = ''
    wrapProgram $out/bin/smpeg2-config \
      --prefix PATH ":" "${pkg-config}/bin" \
      --prefix PKG_CONFIG_PATH ":" "${SDL2.dev}/lib/pkgconfig"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://icculus.org/smpeg/";
    description = "SDL2 MPEG Player Library";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
