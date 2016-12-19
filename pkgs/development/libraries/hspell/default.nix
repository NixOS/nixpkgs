{ stdenv, fetchurl, perl, zlib }:

stdenv.mkDerivation rec {
  name = "${passthru.pname}-${passthru.version}";

  passthru = {
    pname = "hspell";
    version = "1.1";
  };

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "08x7rigq5pa1pfpl30qp353hbdkpadr1zc49slpczhsn0sg36pd6";
  };

  patchPhase = ''patchShebangs .'';
  buildInputs = [ perl zlib ];

  meta = {
    description = "Hebrew spell checker";
    homepage = http://hspell.ivrix.org.il/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
# Note that I don't speak hebrew, so I can only fix compile problems
  };
}
