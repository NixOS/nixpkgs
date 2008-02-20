args: with args;
stdenv.mkDerivation rec {
  name = "libiec61883-1.1.0";

  src = fetchurl {
    url = "${meta.homepage}/dl/${name}.tar.gz";
    sha256 = "09f0ca7bp6lqlz6601gnyl04mfabv0azg49n1cmjyqpzh35cgxkq";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libraw1394];

  meta = { 
      description = "TODO";
      homepage = http://www.linux1394.org;
      license = "LGPL";
    };
}
