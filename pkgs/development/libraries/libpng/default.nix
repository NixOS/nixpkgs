{ lib, stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  patchVersion = "1.6.37";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "1dh0250mw9b2hx7cdmnb2blk7ddl49n6vx8zz7jdmiwxy38v4fw2";
  };
  whenPatched = lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  pname = "libpng" + whenPatched "-apng";
  version = "1.6.37";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1jl8in381z0128vgxnvn33nln6hzckl7l7j9nqvkaf1m9n1p0pjh";
  };
  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = with lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    license = licenses.libpng2;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
