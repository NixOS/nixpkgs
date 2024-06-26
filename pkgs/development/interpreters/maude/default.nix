{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  flex,
  bison,
  ncurses,
  buddy,
  tecla,
  libsigsegv,
  gmpxx,
  cln,
  yices,
  # passthru.tests
  tamarin-prover,
}:

let
  version = "3.3.1";
in

stdenv.mkDerivation {
  pname = "maude";
  inherit version;

  src = fetchurl {
    url = "https://github.com/SRI-CSL/Maude/archive/refs/tags/Maude${version}.tar.gz";
    sha256 = "ueM8qi3fLogWT8bA+ZyBnd9Zr9oOKuoiu2YpG6o5J1E=";
  };

  nativeBuildInputs = [
    flex
    bison
    unzip
    makeWrapper
  ];
  buildInputs = [
    ncurses
    buddy
    tecla
    gmpxx
    libsigsegv
    cln
    yices
  ];

  hardeningDisable =
    [ "stackprotector" ]
    ++ lib.optionals stdenv.isi686 [
      "pic"
      "fortify"
    ];

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
  '';

  passthru.tests = {
    # tamarin-prover only supports specific versions of maude explicitly
    inherit tamarin-prover;
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "http://maude.cs.illinois.edu/";
    description = "High-level specification language";
    mainProgram = "maude";
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
