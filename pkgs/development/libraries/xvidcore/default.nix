{ lib, stdenv, fetchurl, yasm, autoconf, automake, libtool }:

with lib;
stdenv.mkDerivation rec {
  pname = "xvidcore";
  version = "1.3.7";

  src = fetchurl {
    url = "https://downloads.xvid.com/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1xyg3amgg27zf7188kss7y248s0xhh1vv8rrk0j9bcsd5nasxsmf";
  };

  preConfigure = ''
    # Configure script is not in the root of the source directory
    cd build/generic
  '' + optionalString stdenv.isDarwin ''
    # Undocumented darwin hack
    substituteInPlace configure --replace "-no-cpp-precomp" ""
  '';

  configureFlags = [ ]
    # Undocumented darwin hack (assembly is probably disabled due to an
    # issue with nasm, however yasm is now used)
    ++ optional stdenv.isDarwin "--enable-macosx_module --disable-assembly";

  nativeBuildInputs = [ ]
    ++ optional (!stdenv.isDarwin) yasm;

  buildInputs = [ ]
    # Undocumented darwin hack
    ++ optionals stdenv.isDarwin [ autoconf automake libtool ];

  # Don't remove static libraries (e.g. 'libs/*.a') on darwin.  They're needed to
  # compile ffmpeg (and perhaps other things).
  postInstall = optionalString (!stdenv.isDarwin) ''
    rm $out/lib/*.a
  '';

  meta = {
    description = "MPEG-4 video codec for PC";
    homepage    = "https://www.xvid.com/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel lovek323 ];
    platforms   = platforms.all;
  };
}

