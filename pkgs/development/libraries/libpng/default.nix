{ stdenv, fetchurl, zlib, apngSupport ? false}:

assert zlib != null;

let whenPatched = stdenv.lib.optionalString apngSupport;
    version = "1.6.2";
    patch_src = fetchurl {
      url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
      sha256 = "0fy7p197ilr9phwqqk9h91s1mc28r6gj0w2ilrw5liagi71z75j1";
    };

in stdenv.mkDerivation (rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1pljkqjqgyz8c32w8fipd9f0v2gcyhah2ypp0h7ya1r1q85sk5qw";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
    platforms = stdenv.lib.platforms.all;
  };
} // stdenv.lib.optionalAttrs apngSupport {

  postPatch = ''
    gunzip < ${patch_src} | patch -Np1
  '';

})
