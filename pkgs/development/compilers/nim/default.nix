{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nim-0.10.2";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.zip";
    sha256 = "1jkrf8wgva7kfl0vqs1f3scidi6a85r6bkz2zf90k8gdpin9idrg";
  };

  buildPhase   = "sh build.sh";
  installPhase =
    ''
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
