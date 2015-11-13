{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "4.75.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  patches = [
    # backported from
    # https://github.com/dbry/WavPack/commit/12867b33e2de3e95b88d7cb6f449ce0c5c87cdd5
    ./wavpack_clang.patch
  ];

  preConfigure = ''
    sed -i '2iexec_prefix=@exec_prefix@' wavpack.pc.in
  '';

  # --disable-asm is required for clang
  # https://github.com/dbry/WavPack/issues/3
  configureFlags = lib.optionalString stdenv.cc.isClang "--disable-asm";

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "0bmgwcvch3cjcivk7pyasqysj0s81wkg40j3zfrcd7bl0qhmqgn6";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
