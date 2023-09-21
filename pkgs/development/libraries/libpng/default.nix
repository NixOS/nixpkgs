{ lib, stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  patchVersion = "1.6.39";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    hash = "sha256-SsS26roAzeISxI22XLlCkQc/68oixcef2ocJFQLoDP0=";
  };
  whenPatched = lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  pname = "libpng" + whenPatched "-apng";
  version = "1.6.39";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    hash = "sha256-H0aWznC07l+F8eFiPcEimyEAKfpLeu5XPfPiunsDaTc=";
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
    changelog = "https://github.com/glennrp/libpng/blob/v1.6.39/CHANGES";
    license = licenses.libpng2;
    platforms = platforms.all;
    maintainers = with maintainers; [ vcunat ];
  };
}
