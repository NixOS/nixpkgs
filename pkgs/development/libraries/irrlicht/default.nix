{ stdenv, fetchzip, libGLU_combined, unzip, libXrandr, libX11, libXxf86vm }:


stdenv.mkDerivation rec {
  name = "irrlicht-${version}";
  version = "1.8.4";

  src = fetchzip {
    url = "mirror://sourceforge/irrlicht/${name}.zip";
    sha256 = "02sq067fn4xpf0lcyb4vqxmm43qg2nxx770bgrl799yymqbvih5f";
  };

  preConfigure = ''
    cd source/Irrlicht
  '';

  buildPhase = ''
    make sharedlib NDEBUG=1 "LDFLAGS=-lX11 -lGL -lXxf86vm"
  '';

  preInstall = ''
    sed -i s,/usr/local/lib,$out/lib, Makefile
    mkdir -p $out/lib
  '';

  buildInputs = [ unzip libGLU_combined libXrandr libX11 libXxf86vm ];

  meta = {
    homepage = http://irrlicht.sourceforge.net/;
    license = stdenv.lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = stdenv.lib.platforms.linux;
  };
}
