{ stdenv, lib, fetchurl, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "nim-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.tar.xz";
    sha256 = "0rsibhkc5n548bn9yyb9ycrdgaph5kq84sfxc9gabjs7pqirh6cy";
  };

  buildInputs  = [ makeWrapper ];

  buildPhase   = "sh build.sh";

  installPhase =
    ''
      install -Dt "$out/bin" bin/nim
      substituteInPlace install.sh --replace '$1/nim' "$out"
      sh install.sh $out
      wrapProgram $out/bin/nim \
        --suffix PATH : ${lib.makeBinPath [ gcc ]}
    '';

  meta = with stdenv.lib;
    { description = "Statically typed, imperative programming language";
      homepage = http://nim-lang.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ ehmry peterhoeg ];
      platforms = platforms.linux ++ platforms.darwin; # arbitrary
    };
}
