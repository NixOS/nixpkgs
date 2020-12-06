{ stdenv, fetchFromGitHub, makeWrapper }:
let
  version = "0.9.1";
  name = "chibi-scheme-${version}";
in
stdenv.mkDerivation {
  inherit name;

  meta = {
    homepage = "https://github.com/ashinn/chibi-scheme";
    description = "Small Footprint Scheme for use as a C Extension Language";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.DerGuteMoritz ];
  };

  src = fetchFromGitHub {
    owner = "ashinn";
    repo = "chibi-scheme";
    rev = version;
    sha256 = "0nd63i924ifh39cba1hd4sbi6vh1cb73v97nrn4bf8rrjh3k8pdi";
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
