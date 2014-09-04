{ stdenv, fetchurl, makeWrapper }:
let
  version = "0.7";
  name = "chibi-scheme-${version}";
in
stdenv.mkDerivation {
  inherit name;

  meta = {
    homepage = "https://code.google.com/p/chibi-scheme/";
    description = "Small Footprint Scheme for use as a C Extension Language";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.DerGuteMoritz ];
  };

  src = fetchurl {
    url = "http://abrek.synthcode.com/${name}.tgz";
    sha256 = "1hhkq0khgi8i24xv66y7r6pgk1issn1i2bf7rv91rbk0wm0kv7qm";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    make install PREFIX="$out"
  '';

  fixupPhase = ''
    wrapProgram "$out/bin/chibi-scheme" \
      --prefix CHIBI_MODULE_PATH : "$out/share/chibi:$out/lib/chibi"

    for f in chibi-doc chibi-ffi snow-chibi; do
      substituteInPlace "$out/bin/$f" \
        --replace "/usr/bin/env chibi-scheme" "$out/bin/chibi-scheme"
    done
  '';
}
