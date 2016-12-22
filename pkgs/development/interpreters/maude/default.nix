{ stdenv, fetchurl, unzip, makeWrapper
, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx,
}:

let

  version = "2.7";

  fullMaude = fetchurl {
    url = "https://raw.githubusercontent.com/maude-team/full-maude/master/full-maude27c.maude";
    sha256 = "08bg3gn1vyjy5k69hnynpzc9s1hnrbkyv6z08y1h2j37rlc4c18y";
  };

in

stdenv.mkDerivation rec {
  name = "maude-${version}";

  src = fetchurl {
    url = "https://github.com/maude-team/maude/archive/v${version}-ext-hooks.tar.gz";
    sha256 = "02p0snxm69rs8pvm93r91p881dw6p3bxmazr3cfw5pnxpgz0vjl0";
  };

  buildInputs = [flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper unzip];

  hardeningDisable = [ "stackprotector" ] ++
    stdenv.lib.optionals stdenv.isi686 [ "pic" "fortify" ];

  preConfigure = ''
    configureFlagsArray=(
      --datadir="$out/share/maude"
      TECLA_LIBS="-ltecla -lncursesw"
      CFLAGS="-O3" CXXFLAGS="-O3"
    )
  '';

  doCheck = true;

  postInstall = ''
    for n in "$out/bin/"*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    install -D -m 444 ${fullMaude} $out/share/maude/full-maude.maude
  '';

  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
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

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
