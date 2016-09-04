{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "tnt-${version}";
  version = "3.0.12";
  
  src = fetchurl {
    url = http://math.nist.gov/tnt/tnt_3_0_12.zip;
    sha256 = "1bzkfdb598584qlc058n8wqq9vbz714gr5r57401rsa9qaxhk5j7";
  };

  buildInputs = [ unzip ];

  installPhase = ''
      mkdir -p $out/include
      cp *.h $out/include
  '';

  meta = {
    homepage = http://math.nist.gov/tnt/;
    description = "Template Numerical Toolkit: C++ headers for array and matrices";
    platforms = stdenv.lib.platforms.unix;
  };
}
