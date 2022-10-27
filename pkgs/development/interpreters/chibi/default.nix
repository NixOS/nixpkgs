{ lib, stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.10";
  pname = "chibi-scheme";

  src = fetchFromGitHub {
    owner = "ashinn";
    repo = "chibi-scheme";
    rev = version;
    sha256 = "sha256-7vDxcnXhq1wJSLFHGxtwh+H+KWxh6B0JXSMPzSmQFXo=";
  };

  nativeBuildInputs = [ makeWrapper ];

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

  meta = {
    homepage = "https://github.com/ashinn/chibi-scheme";
    description = "Small Footprint Scheme for use as a C Extension Language";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.DerGuteMoritz ];
  };
}
