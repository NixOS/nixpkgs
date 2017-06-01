{ fetchsvn, stdenv, mesa, unzip, libXrandr, libX11, libXxf86vm }:


stdenv.mkDerivation rec {
  name = "irrlicht-${version}-svn-${revision}";
  version = "1.8";
  revision = "5104"; # newest revision as of 05-16-15

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/irrlicht/code/branches/releases/${version}"; # get 1.8 release (same regardless of rev)
    rev = "${revision}";
    sha256 = "18xvlrjf113mphf29iy24hmrkh7xff6j9cz0chrxjqbr9xk9h1yq";
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

  buildInputs = [ unzip mesa libXrandr libX11 libXxf86vm ];

  meta = {
    homepage = http://irrlicht.sourceforge.net/;
    license = stdenv.lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = stdenv.lib.platforms.linux;
  };
}
