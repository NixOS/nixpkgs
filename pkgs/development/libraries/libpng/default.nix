{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.12";
  sha256 = "0pkcirbfzhqqsm3hr2alxprw5n22a836qk4df1jnns6jk79gcby3";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0r2vmsc4cvxisjr7jqw2vjf66isb2fhs4nnssz3l3jgdangj8wz0";
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
