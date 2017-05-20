{ stdenv, fetchFromGitHub, cmake, SDL2, zlib, libjpeg, libpng, libvorbis, mesa_glu, haxe }:

stdenv.mkDerivation rec {
  name = "hashlink-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "000k7a88fdkavy0x43hrggwck3zn1g61pc9m1nal5nfj1qi4r8qf";
  };

  nativeBuildInputs = [ cmake haxe ];
  buildInputs = [ SDL2 zlib libjpeg libpng libvorbis mesa_glu ];

  installPhase = ''
    mkdir -p $out/{bin,include,lib}
    cp -dpR bin/* $out/lib/
    mv $out/lib/{hl,hello.hl} $out/bin/

    # generated C-code #includes the sources
    cp -dpR ../src/* $out/include/
  '';

  meta = with stdenv.lib; {
    description = "Virtual machine for Haxe";
    homepage = http://hashlink.haxe.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
  };
}