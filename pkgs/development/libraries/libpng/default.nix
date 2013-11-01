{ stdenv, fetchurl, zlib, apngSupport ? false }:

assert zlib != null;

let
  version = "1.6.4";
  sha256 = "15pqany43q2hzaxqn84p9dba071xmvqi8h1bhnjxnxdf3g64zayg";
  patch_src = fetchurl { # not released yet, hopefully OK
    url = "mirror://sourceforge/libpng-apng/libpng-1.6.3-apng.patch.gz";
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

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
