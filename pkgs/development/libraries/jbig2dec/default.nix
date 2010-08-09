{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "jbig2dec-0.11";
  
  src = fetchurl {
    url = http://ghostscript.com/~giles/jbig2/jbig2dec/jbig2dec-0.11.tar.gz;
    sha256 = "1ffhgmf2fqzk0h4k736pp06z7q5y4x41fg844bd6a9vgncq86bby";
  };
  
  meta = {
    homepage = http://jbig2dec.sourceforge.net/;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = "GPLv2+";
  };
}
