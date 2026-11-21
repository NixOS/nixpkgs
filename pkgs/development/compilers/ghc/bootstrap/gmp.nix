# GMP 6.1.2, the last release before 6.2 made mpz_init lazy.  Newer GMP leaves
# a zero result pointing at a static limb, which GHC before 8.0 treats as a heap
# object that its garbage collector then follows.
{
  stdenv,
  fetchurl,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmp";
  version = "6.1.2";

  src = fetchurl {
    url = "mirror://gnu/gmp/gmp-${finalAttrs.version}.tar.xz";
    hash = "sha256-h7Vl6JqaaE/k6+7duDmdziWZ+ckEmFTKjA373qDiGRI=";
  };

  nativeBuildInputs = [ m4 ];

  hardeningDisable = [ "all" ];

  # The K&R test programs of a 2016 configure fail under C23
  env.CFLAGS = "-O2 -std=gnu11";

  configureFlags = [
    # Generic C, so the result does not depend on the build machine's CPU
    "--disable-assembly"
    "--with-pic"
  ];

  enableParallelBuilding = true;

  doCheck = true;
})
