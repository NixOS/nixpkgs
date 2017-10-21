{ stdenv, fetchurl, unzip }:
        
stdenv.mkDerivation rec {
  name = "lib3ds-1.3.0";

  src = fetchurl {
    url = "http://lib3ds.googlecode.com/files/${name}.zip";
    sha256 = "1qr9arfdkjf7q11xhvxwzmhxqz3nhcjkyb8zzfjpz9jm54q0rc7m";
  };

  buildInputs = [ unzip ];

  meta = { 
    description = "Library for managing 3D-Studio Release 3 and 4 \".3DS\" files";
    homepage = http://lib3ds.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.unix;
  };
}

