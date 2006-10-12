{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;
assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "gcc-4.0.1-apple-5341";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.opensource.apple.com/darwinsource/tarballs/other/gcc-5341.tar.gz;
    md5 = "a135f107ddc55b773b40dfff4f049640";
  };
  patches =
    [./pass-cxxcpp.patch]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
}
