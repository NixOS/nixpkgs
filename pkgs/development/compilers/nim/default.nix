{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.14.2";

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.tar.xz";
    sha256 = "14jy7wza54jawja21r6v676qyj0i9kg1jpn5bxwn8wfm1vbki3cg";
  };

  buildPhase   = "sh build.sh";
  installPhase =
    ''
      install -Dt "$out/bin" bin/nim
      substituteInPlace install.sh --replace '$1/nim' "$out"
      sh install.sh $out
    '';

  meta = with stdenv.lib;
    { description = "Statically typed, imperative programming language";
      homepage = http://nim-lang.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.linux ++ platforms.darwin; # arbitrary
    };
}
