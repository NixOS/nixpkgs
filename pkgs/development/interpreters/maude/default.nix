{ lib, stdenv, fetchurl, unzip, makeWrapper, flex, bison, ncurses, buddy, tecla
, libsigsegv, gmpxx, cln, yices
}:

let

  version = "3.2.1";

  fullMaude = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/b/bc/Full-Maude-${version}.zip";
    sha256 = "B1GzxGGSg7PwrfHDqsET8dQzSjyoWe0A1m3l9YV1Y+w=";
  };

in

stdenv.mkDerivation {
  pname = "maude";
  inherit version;

  src = fetchurl {
    url = "https://github.com/SRI-CSL/Maude/archive/refs/tags/${version}.tar.gz";
    sha256 = "Hs0ASz8cOo3BcTddjPihNRgE8rw0jFogeYnkTklM8Vk=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper cln yices
  ];

  hardeningDisable = [ "stackprotector" ] ++
    lib.optionals stdenv.isi686 [ "pic" "fortify" ];

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
    install -D -m 444 full-maude31.maude $out/share/maude/full-maude.maude
  '';

  # bison -dv surface.yy -o surface.c
  # mv surface.c surface.cc
  # mv: cannot stat 'surface.c': No such file or directory
  enableParallelBuilding = false;

  meta = {
    homepage = "http://maude.cs.illinois.edu/";
    description = "High-level specification language";
    license = lib.licenses.gpl2Plus;

    longDescription = ''
      Maude is a high-performance reflective language and system
      supporting both equational and rewriting logic specification and
      programming for a wide range of applications. Maude has been
      influenced in important ways by the OBJ3 language, which can be
      regarded as an equational logic sublanguage. Besides supporting
      equational specification and programming, Maude also supports
      rewriting logic computation.
    '';

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
}
