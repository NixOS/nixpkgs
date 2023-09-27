{ lib, stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  patchVersion = "1.6.40";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    hash = "sha256-CjykZIKTjY1sciZivtLH7gxlobViRESzztIa2NNW2y8=";
  };
  whenPatched = lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  pname = "libpng" + whenPatched "-apng";
  version = "1.6.40";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    hash = "sha256-U1tHmyRn/yMaPsbZKlJZBvuO8nl4vk9m2+BdPzoBs6E=";
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
    changelog = "https://github.com/glennrp/libpng/blob/v1.6.40/CHANGES";
    license = licenses.libpng2;
    platforms = platforms.all;
    maintainers = with maintainers; [ vcunat ];
  };
}
