{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.15.0";

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.tar.xz";
    sha256 = "1yv9qvc1r7m0m4gwi8mgnabdjz70mwxf5rmv8xhibcmja1856565";
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
