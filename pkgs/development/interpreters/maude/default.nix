{ stdenv, fetchurl, unzip, makeWrapper, flex, bison, ncurses, buddy, tecla
, libsigsegv, gmpxx, cln, yices
}:

let

  version = "3.0";

  fullMaude = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/0/04/Full-Maude-${version}.zip";
    sha256 = "0gf36wlkkl343vlxgryqdhxmgyn8z0cc2zayccd7ac3inmj1iayw";
  };

in

stdenv.mkDerivation {
  pname = "maude";
  inherit version;

  src = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/9/92/Maude-${version}.tar.gz";
    sha256 = "0vhn3lsck6ji9skrgm67hqrn3k4f6y442q73jbw65qqznm321k5a";
  };

  buildInputs = [
    flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper unzip cln yices
  ];

  hardeningDisable = [ "stackprotector" ] ++
    stdenv.lib.optionals stdenv.isi686 [ "pic" "fortify" ];

  preConfigure = ''
    configureFlagsArray=(
      --datadir="$out/share/maude"
      TECLA_LIBS="-ltecla -lncursesw"
      LIBS="-lcln"
      CFLAGS="-O3" CXXFLAGS="-O3"
    )
  '';

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    unzip ${fullMaude}
    install -D -m 444 full-maude3.maude $out/share/maude/full-maude.maude
  '';

  # bison -dv surface.yy -o surface.c
  # mv surface.c surface.cc
  # mv: cannot stat 'surface.c': No such file or directory
  enableParallelBuilding = false;

  meta = {
    homepage = http://maude.cs.illinois.edu/;
    description = "High-level specification language";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Maude is a high-performance reflective language and system
      supporting both equational and rewriting logic specification and
      programming for a wide range of applications. Maude has been
      influenced in important ways by the OBJ3 language, which can be
      regarded as an equational logic sublanguage. Besides supporting
      equational specification and programming, Maude also supports
      rewriting logic computation.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
