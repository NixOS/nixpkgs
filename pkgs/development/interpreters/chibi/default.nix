{ stdenv, fetchFromGitHub, makeWrapper }:
let
  version = "0.7.3";
  name = "chibi-scheme-${version}";
in
stdenv.mkDerivation {
  inherit name;

  meta = {
    homepage = https://github.com/ashinn/chibi-scheme;
    description = "Small Footprint Scheme for use as a C Extension Language";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.DerGuteMoritz ];
  };

  src = fetchFromGitHub {
    owner = "ashinn";
    repo = "chibi-scheme";
    rev = version;
    sha256 = "05b17flppkll1a2c2aq6lxh4iif4pjmpxmyrmiqzk0ls85gvai2x";
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
