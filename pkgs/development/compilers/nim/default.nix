{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.11.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.zip";
    sha256 = "0l19rrp6nhwhr2z33np4x32c35iba0hhv6w3qwj1sk8bjfpvz4cw";
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
