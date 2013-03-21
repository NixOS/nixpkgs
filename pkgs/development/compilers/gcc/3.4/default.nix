{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

with stdenv.lib;

stdenv.mkDerivation {
  name = "gcc-3.4.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/gcc/gcc-3.4.6/gcc-3.4.6.tar.bz2;
    md5 = "4a21ac777d4b5617283ce488b808da7b";
  };

  patches = stdenv.lib.optional noSysDirs ./no-sys-dirs.patch;

  # inspiration: https://aur.archlinux.org/packages/g77/
  postPatch = ''
    substituteInPlace gcc/config/i386/linux.h --replace 'struct siginfo' siginfo_t
  '';

  inherit noSysDirs profiledCompiler;

  configureFlags = "
    --disable-multilib
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC   "c"
        ++ optional langCC  "c++"
        ++ optional langF77 "f77"
        )
      )
    }
  ";

  passthru = { inherit langC langCC langF77; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 3.4.x";
  };
}
