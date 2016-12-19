{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.15.2";

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.tar.xz";
    sha256 = "12pyzjx7x4hclzrf3zf6r1qjlp60bzsaqrz0rax2rak2c8qz4pch";
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
