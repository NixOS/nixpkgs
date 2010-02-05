{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.42";
  
  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.gz";
    md5 = "562066eb8557db91156eaeb309458488";
  };
  
  propagatedBuildInputs = [zlib];
  
  inherit zlib;

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}

