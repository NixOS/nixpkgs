{ stdenv, fetchurl, zlib, apngSupport ? true
, buildPlatform, hostPlatform
}:

assert zlib != null;

let
  version = "1.6.29";
  patchVersion = "1.6.26";
  # patchVersion = version;
  sha256 = "0fgjqp7x6jynacmqh6dj72cn6nnf6yxjfqqqfsxrx0pyx22bcia2";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
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
