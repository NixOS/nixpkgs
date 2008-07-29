{ fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  name = "crypto++-5.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/cryptopp/cryptopp552.zip";
    sha256 = "0nd783wk3gl36nfa9zmwxw6pn4n5p8mld7jf5dc1j9iy0gmqv3q7";
  };

  buildInputs = [ unzip ];

  # Unpack the thing in a subdirectory.
  unpackPhase = ''
    echo "unpacking Crypto++ to \`${name}' from \`$PWD'..."
    mkdir "${name}" && (cd "${name}" && unzip "$src")
    sourceRoot="$PWD/${name}"
  '';

  buildPhase = ''make PREFIX="$out"'';
  installPhase = ''mkdir "$out" && make install PREFIX="$out"'';

  meta = {
    description = "Crypto++, a free C++ class library of cryptographic schemes";
    homepage = http://cryptopp.com/;
    license = "Public Domain";
  };
}