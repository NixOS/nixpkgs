{stdenv, fetch, fetchpatch, llvm, gmp, mpfr, mpc, ncurses, zlib, version}:

stdenv.mkDerivation rec {
  name = "dragonegg-${version}";

  src = fetch "dragonegg" "34bf35c7d5f395fdc1e2a6b8ddbd83fc2e5027a895333efbe03cf8b5d767639c";

  patches = [(fetchpatch {
    url = "https://llvm.org/viewvc/llvm-project/dragonegg/trunk/src/x86/ABIHack.inc"
      + "?r1=208730&r2=208729&view=patch";
    sha256 = "1al82gqz90hzjx24p0wls029lw2bgnlgd209kgvxsp82p4z1v1c1";
    name = "bug-18548.patch";
  })];
  patchFlags = "-p2";

  # The gcc the plugin will be built for (the same used building dragonegg)
  GCC = "gcc";

  buildInputs = [ llvm gmp mpfr mpc ncurses zlib ];

  installPhase = ''
    mkdir -p $out/lib $out/share/doc/${name}
    cp -d dragonegg.so $out/lib
    cp README COPYING $out/share/doc/${name}
  '';

  meta = {
    homepage = http://dragonegg.llvm.org/;
    description = "gcc plugin that replaces gcc's optimizers and code generators by those in LLVM";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}
