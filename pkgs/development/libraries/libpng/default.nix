{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  version = "1.6.18";
  sha256 = "0qq96rf31483kxz32h6l6921hy6p2v2pfqfvc74km229g4xw241f";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0g2ljh2vhclas1hacys1c4gk6l6hyy6sngb2yvdsnjz50nyq16kv";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    inherit sha256;
  };

  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
