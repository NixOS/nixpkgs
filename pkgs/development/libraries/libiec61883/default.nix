args: with args;
stdenv.mkDerivation {
  name = "libiec61883-1.1.0";

  src = fetchurl {
    url = http://www.linux1394.org/dl/libiec61883-1.1.0.tar.gz;
    sha256 = "09f0ca7bp6lqlz6601gnyl04mfabv0azg49n1cmjyqpzh35cgxkq";
  };

  buildInputs = [pkgconfig libraw1394];

  meta = { 
      description = "TODO";
      homepage = http://www.linux1394.org/;
      license = "LGPL";
    };
}
