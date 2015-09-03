{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.11.2";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.zip";
    sha256 = "0ay8gkd8fki3d8kbnw2px7rjdlr54kyqh5n1rjhq4vjmqs2wg5s4";
  };

  buildPhase   = "sh build.sh";
  installPhase =
    ''
      installBin bin/nim
      substituteInPlace install.sh --replace '$1/nim' "$out"
      sh install.sh $out
    '';

  meta = with stdenv.lib;
    { description = "Statically typed, imperative programming language";
      homepage = http://nim-lang.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ emery ];
      platforms = platforms.linux; # arbitrary
    };
}
