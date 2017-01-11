{ fetchurl, buildPerlPackage, zlib, stdenv }:

buildPerlPackage rec {
  name = "Compress-Raw-Zlib-2.071";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${name}.tar.gz";
    sha256 = "0dk7pcmhnl7n811q3p4rrz5ijdhz6jx367h6rypgvg1y39z4arfs";
  };

  preConfigure = ''
    cat > config.in <<EOF
      BUILD_ZLIB   = False
      INCLUDE      = ${zlib.dev}/include
      LIB          = ${zlib.out}/lib
      OLD_ZLIB     = False
      GZIP_OS_CODE = AUTO_DETECT
    EOF
  '';

  # Try untested for now.  Upstream bug:
  # https://rt.cpan.org/Public/Bug/Display.html?id=119762
  doCheck = false && !stdenv.isDarwin;

  meta = {
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
  };
}
