{ stdenv, fetchurl, unzip, makeWrapper , flex, bison, ncurses, buddy, tecla
, libsigsegv, gmpxx, cln
}:

let

  version = "2.7.1";

  fullMaude = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/c/ca/Full-Maude-${version}.zip";
    sha256 = "0y4gn7n8vh24r24vckhpkd46hb5hqsbrm4w9zr6dz4paafq12fjc";
  };

in

stdenv.mkDerivation rec {
  name = "maude-${version}";

  src = fetchurl {
    url = "http://maude.cs.illinois.edu/w/images/d/d8/Maude-${version}.tar.gz";
    sha256 = "0jskn5dm8vvbd3mlryjxdb6wfpkvyx174wk7ci9a31aylxzpr25i";
  };

  buildInputs = [
    flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper unzip cln
  ];

  hardeningDisable = [ "stackprotector" ] ++
    stdenv.lib.optionals stdenv.isi686 [ "pic" "fortify" ];

  preConfigure = ''
    configureFlagsArray=(
      --datadir="$out/share/maude"
      TECLA_LIBS="-ltecla -lncursesw"
      LIBS="-lcln"
      CFLAGS="-O3" CXXFLAGS="-O3"
      --without-cvc4    # Our version is too new for Maude to cope.
    )
  '';

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    unzip ${fullMaude}
    install -D -m 444 full-maude.maude $out/share/maude/full-maude.maude
  '';

  meta = {
    homepage = http://maude.cs.illinois.edu/;
    description = "High-level specification language";
    license = stdenv.lib.licenses.gpl2;

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
