{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  zlib,
  apngSupport ? true,
  testers,
}:

assert zlib != null;

let
  patchVersion = "1.6.46";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    hash = "sha256-Kb7C39BG71HVLz5TIPkfr/yWvge0HZy51D2d9Veg0wM=";
  };
  whenPatched = lib.optionalString apngSupport;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "libpng" + whenPatched "-apng";
  version = "1.6.46";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${finalAttrs.version}.tar.xz";
    hash = "sha256-86qLcAOZirkqTpkGwY0ZhT6Zn507ypvRZo9U+oFwfLE=";
  };

  patches = [
    # see https://github.com/pnggroup/libpng/security/advisories/GHSA-7wv6-48j4-hj3g
    (fetchpatch {
      name = "CVE-2025-65018.1.patch";
      url = "https://github.com/pnggroup/libpng/commit/16b5e3823918840aae65c0a6da57c78a5a496a4d.diff";
      hash = "sha256-pC7G/6IUCWkt9nE5RHnn8jT24KAo91y3f3+d2Us/gB0=";
    })
    (fetchpatch {
      name = "CVE-2025-65018.2.patch";
      url = "https://github.com/pnggroup/libpng/commit/218612ddd6b17944e21eda56caf8b4bf7779d1ea.diff";
      hash = "sha256-jleVnBrsrTmRJqDo87slb7f8yETh3HN9geEwNBRZaGY=";
    })
  ];

  postPatch =
    whenPatched "gunzip < ${patch_src} | patch -Np1"
    + lib.optionalString stdenv.hostPlatform.isFreeBSD ''

      sed -i 1i'int feenableexcept(int __mask);' contrib/libtests/pngvalid.c
    '';

  outputs = [
    "out"
    "dev"
    "man"
  ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = {
    inherit zlib;

    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description =
      "Official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    changelog = "https://github.com/pnggroup/libpng/blob/v${finalAttrs.version}/CHANGES";
    license = licenses.libpng2;
    pkgConfigModules = [
      "libpng"
      "libpng16"
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ vcunat ];
  };
})
