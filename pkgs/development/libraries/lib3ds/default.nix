args:
args.stdenv.mkDerivation {
  name = "lib3ds";

  src = args.fetchurl {
    url = mirror://sourceforge/lib3ds/lib3ds-1.3.0.zip;
    sha256 = "1qr9arfdkjf7q11xhvxwzmhxqz3nhcjkyb8zzfjpz9jm54q0rc7m";
  };

  buildInputs =(with args; [unzip]);

  meta = { 
      description = "library for managing 3D-Studio Release 3 and 4 \".3DS\" files";
      homepage = http://lib3ds.sourceforge.net/;
      license = "LGPL";
    };
}

