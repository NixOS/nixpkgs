{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  patchVersion = "1.6.34";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "1ha4npf9mfrzp0srg8a5amks5ww84xzfpjbsj8k3yjjpai798qg6";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";
  version = "1.6.34";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1xjr0v34fyjgnhvaa1zixcpx5yvxcg4zwvfh0fyklfyfj86rc7ig";
  };
  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
