{ stdenv, fetchurl, zlib, apngSupport ? true
, buildPlatform, hostPlatform
}:

assert zlib != null;

let
  version = "1.6.31";
  patchVersion = "1.6.31";
  sha256 = "0hcbxv9qf4f9q7brrk0ndag526glr8lii43grssv45j9w0nn0ai3";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "0f10ih658j514vpvsli0pk378vcmjn78g52cssyg92r4k1r19rla";
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
  doCheck = hostPlatform == buildPlatform;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
