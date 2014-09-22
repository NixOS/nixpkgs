{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.13";
  sha256 = "09g631h1f1xvrdiy36mh1034r9w46damp9jcg7nm507wlmacxj6r";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "017pnxp3zhhlh6mg2yqn5xrb6dcxc5p3dp1kr46p8xx052i0hzqb";
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
