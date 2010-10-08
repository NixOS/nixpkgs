{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  version = "1.4.4";
  name = "libpng-apng-${version}";
  
  patch_src = fetchurl {
    url = "mirror://sourceforge/project/libpng-apng/libpng-master/${version}/libpng-${version}-apng.patch.gz";
    sha256 = "d729a2feacfd80547e06c30343d598302f4417cf2e6f649e4ee617690987bd24";
  };

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.gz";
    sha256 = "d07616ba1e9c161017384feb3b576d70c160b970abfd9549ad39a622284b574a";
  };

  preConfigure = ''
    gunzip < ${patch_src} | patch -Np1
  '';
  
  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };
  
  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
