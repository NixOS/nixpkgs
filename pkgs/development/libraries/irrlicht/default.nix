{ fetchsvn, stdenv, mesa, unzip, libXrandr, libX11, libXxf86vm }:


stdenv.mkDerivation rec {
  # Version 3843 is required for supertuxkart
  name = "irrlicht-1.8-svn-3843";

  src = fetchsvn {
    url = https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk;
    rev = 3843;
    sha256 = "0v31l3k0fzy7isdsx2sh0baaixzlml1m7vgz6cd0015d9f5n99vl";
  };

  patchPhase = ''
    sed -i /stdcall-alias/d source/Irrlicht/Makefile
  '';

  preConfigure = ''
    cd source/Irrlicht
  '';

  buildPhase = ''
    make sharedlib NDEBUG=1
  '';

  preInstall = ''
    sed -i s,/usr/local/lib,$out/lib, Makefile
    mkdir -p $out/lib
  '';

  postInstall = ''
    ln -s libIrrlicht.so.1.8.0-SVN $out/lib/libIrrlicht.so.1.8
    ln -s libIrrlicht.so.1.8.0-SVN $out/lib/libIrrlicht.so
  '';

  buildInputs = [ unzip mesa libXrandr libX11 libXxf86vm ];

  meta = {
    homepage = http://irrlicht.sourceforge.net/;
    license = "zlib";
    description = "Open source high performance realtime 3D engine written in C++";
  };
}
