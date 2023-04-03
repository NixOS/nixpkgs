{ lib, stdenv, fetchurl, unzip, makeWrapper, flex, bison, ncurses, buddy, tecla
, libsigsegv, gmpxx, cln, yices
}:

let

  version = "3.3";

  fullMaude = fetchurl {
    url = "https://maude.cs.illinois.edu/w/images/b/bc/Full-Maude-3.2.1.zip";
    sha256 = "0751b3c4619283b3f0adf1c3aac113f1d4334a3ca859ed00d66de5f5857563ec";
  };

in

stdenv.mkDerivation {
  pname = "maude";
  inherit version;

  src = fetchurl {
    url = "https://github.com/SRI-CSL/Maude/archive/refs/tags/Maude${version}.tar.gz";
    sha256 = "aebf21523ba7999b4594e315d49b92c5feaef7ca5d176e2e62a8ee1b901380c6";
  };

  nativeBuildInputs = [ flex bison unzip makeWrapper ];
  buildInputs = [
    ncurses buddy tecla gmpxx libsigsegv cln yices
  ];

  hardeningDisable = [ "stackprotector" ] ++
    lib.optionals stdenv.isi686 [ "pic" "fortify" ];

  # Fix for glibc-2.34, see
  # https://gitweb.gentoo.org/repo/gentoo.git/commit/dev-lang/maude/maude-3.1-r1.ebuild?id=f021cc6cfa1e35eb9c59955830f1fd89bfcb26b4
  configureFlags = [ "--without-libsigsegv" ];

  # Certain tests (in particular, Misc/fileTest) expect us to build in a subdirectory
  # We'll use the directory Opt/ as suggested in INSTALL
  preConfigure = ''
    mkdir Opt; cd Opt
    configureFlagsArray=(
      --datadir="$out/share/maude"
      TECLA_LIBS="-ltecla -lncursesw"
      LIBS="-lcln"
      CFLAGS="-O3" CXXFLAGS="-O3"
    )
  '';
  configureScript = "../configure";

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    unzip ${fullMaude}
    install -D -m 444 full-maude.maude $out/share/maude/full-maude.maude
  '';

  # bison -dv surface.yy -o surface.c
  # mv surface.c surface.cc
  # mv: cannot stat 'surface.c': No such file or directory
  enableParallelBuilding = false;

  meta = {
    broken = stdenv.isDarwin;
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
