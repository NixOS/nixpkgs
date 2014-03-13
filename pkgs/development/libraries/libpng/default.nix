{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.10";
  sha256 = "0mjsfxc18478y1jxrs3snmx7mvckmghvki9gfhmhl49n1vyz00s0";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0512q27c26ajzqm2qzmmc7q1frj7cjylls2hxy3y3wg2r6ryizw8";
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
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
