{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  version = "1.6.26";
  sha256 = "1ybkgcqqsd4iiiyv60pxjfi1csszb50bd2cxxsy3sv4q4sil6rr6";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${version}-apng.patch.gz";
    sha256 = "0b6p2k4afvhk1svargpllcvhxb4g3p857wkqk85cks0yv42ckph1";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    inherit sha256;
  };
  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  # it's hard to cross-run tests and some check programs didn't compile anyway
  makeFlags = stdenv.lib.optional (!doCheck) "check_PROGRAMS=";
  doCheck = ! stdenv ? cross;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
