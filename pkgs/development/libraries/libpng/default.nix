{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.3";
  sha256 = "0i8gz8mbkygc0ny7aa2i2wiavysxy6fdaphl52l49fb3hv9w1v65";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0fjnb6cgbj2c7ggl0qzcnliml2ylrjxzigp89vw0hxq221k5mlsx";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    inherit sha256;
  };

  outputs = [ "dev" "out" "man" ];

  preConfigure = "export bin=$dev";

  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
    platforms = stdenv.lib.platforms.all;
  };
}
