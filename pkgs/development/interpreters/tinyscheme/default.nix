{ lib, stdenv, fetchurl, dos2unix }:

stdenv.mkDerivation rec {
  pname = "tinyscheme";
  version = "1.42";

  src = fetchurl {
    url = "mirror://sourceforge/tinyscheme/${pname}-${version}.tar.gz";
    sha256 = "sha256-F7Cxv/0i89SdWDPiKhILM5A50s/aC0bW/FHdLwG0B60=";
  };

  nativeBuildInputs = [ dos2unix ];

  prePatch = "dos2unix makefile";
  patches = [
    # We want to have the makefile pick up $CC, etc. so that we don't have
    # to unnecessarily tie this package to the GCC stdenv.
    ./02-use-toolchain-env-vars.patch
  ];
  postPatch = ''
    substituteInPlace scheme.c --replace "init.scm" "$out/lib/init.scm"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp init.scm $out/lib
    cp libtinyscheme* $out/lib
    cp scheme $out/bin/tinyscheme
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Lightweight Scheme implementation";
    longDescription = ''
      TinyScheme is a lightweight Scheme interpreter that implements as large a
      subset of R5RS as was possible without getting very large and complicated.
    '';
    homepage = "http://tinyscheme.sourceforge.net/";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
    badPlatforms = [ "aarch64-darwin" ];
  };
}
