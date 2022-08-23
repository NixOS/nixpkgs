{ lib, stdenv, fetchurl, unzip, makeWrapper, flex, bison, ncurses, buddy, tecla
, libsigsegv, gmpxx, cln, yices
}:

let

  version = "3.1";

  fullMaude = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/0/0a/Full-Maude-${version}.zip";
    sha256 = "8b13af02c6243116c2ef9592622ecaa06d05dbe1dd6b1e595551ff33855948f2";
  };

in

stdenv.mkDerivation {
  pname = "maude";
  inherit version;

  src = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/d/d3/Maude-${version}.tar.gz";
    sha256 = "b112d7843f65217e3b5a9d40461698ef8dab7cbbe830af21216dfb924dc88a2f";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper cln yices
  ];

  hardeningDisable = [ "stackprotector" ] ++
    lib.optionals stdenv.isi686 [ "pic" "fortify" ];

  # Fix for glibc-2.34, see
  # https://gitweb.gentoo.org/repo/gentoo.git/commit/dev-lang/maude/maude-3.1-r1.ebuild?id=f021cc6cfa1e35eb9c59955830f1fd89bfcb26b4
  configureFlags = [ "--without-libsigsegv" ];

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
