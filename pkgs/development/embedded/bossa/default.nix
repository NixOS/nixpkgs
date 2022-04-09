{ lib, stdenv, fetchFromGitHub, wxGTK, libX11, readline }:

let
  # BOSSA needs a "bin2c" program to embed images.
  # Source taken from:
  # http://wiki.wxwidgets.org/Embedding_PNG_Images-Bin2c_In_C
  bin2c = stdenv.mkDerivation {
    name = "bossa-bin2c";
    src = ./bin2c.c;
    dontUnpack = true;
    buildPhase = "cc $src -o bin2c";
    installPhase = "mkdir -p $out/bin; cp bin2c $out/bin/";
  };

in
stdenv.mkDerivation rec {
  pname = "bossa";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "shumatech";
    repo = "BOSSA";
    rev = version;
    sha256 = "sha256-dZeBy63OzIaLUfAg6awnk83FtLKVxPoYAYs5t7BBM6Y=";
  };

  patches = [ ./bossa-no-applet-build.patch ];

  nativeBuildInputs = [ bin2c ];
  buildInputs = [ wxGTK libX11 readline ];

  # Explicitly specify targets so they don't get stripped.
  makeFlags = [ "bin/bossac" "bin/bossash" "bin/bossa" ];
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/bossa{c,sh,} $out/bin/
  '';

  meta = with lib; {
    description = "A flash programming utility for Atmel's SAM family of flash-based ARM microcontrollers";
    longDescription = ''
      BOSSA is a flash programming utility for Atmel's SAM family of
      flash-based ARM microcontrollers. The motivation behind BOSSA is
      to create a simple, easy-to-use, open source utility to replace
      Atmel's SAM-BA software. BOSSA is an acronym for Basic Open
      Source SAM-BA Application to reflect that goal.
    '';
    homepage = "http://www.shumatech.com/web/products/bossa";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
