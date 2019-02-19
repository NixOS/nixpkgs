{ stdenv, fetchurl, zlib, apngSupport ? true }:

assert zlib != null;

let
  patchVersion = "1.6.36";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    sha256 = "03ywdwaq1k3pfslvbs2b33z3pdmazz6yp8g56mzafacvfgd367wc";
  };
  whenPatched = stdenv.lib.optionalString apngSupport;

in stdenv.mkDerivation rec {
  name = "libpng" + whenPatched "-apng" + "-${version}";
  version = "1.6.36";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "06d35a3xz2a0kph82r56hqm1fn8fbwrqs07xzmr93dx63x695szc";
  };
  patches = if !stdenv.hostPlatform.isAarch64 then null # temporarily avoid rebuild
  else [
    (fetchurl { # https://github.com/glennrp/libpng/issues/266
      url = "https://salsa.debian.org/debian/libpng1.6/raw/0e1348f3d/debian/patches/272.patch";
      sha256 = "1d36khgryq2p27bdx10xrr4kcjr7cdfdj2zhdcjzznpnpns97s6n";
    })
    (fetchurl { # https://github.com/glennrp/libpng/issues/275
      url = "https://salsa.debian.org/debian/libpng1.6/raw/853d1977/debian/patches/CVE-2019-7317.patch";
      sha256 = "0c8qc176mqh08kcxlnx40rzdggchihkrlzqw6qg6lf0c9ygkf55k";
    })
  ];
  postPatch = whenPatched "gunzip < ${patch_src} | patch -Np1";

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng2;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat maintainers.fuuzetsu ];
  };
}
