{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pforth";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "philburk";
    repo = "pforth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vEjFeHSJl+yAtatYJEnu+r9hmOr/kZOgIbSUXR/c8WU=";
  };

  dontConfigure = true;

  preBuild = ''
    cd platforms/unix
  '';

  installPhase = ''
    install -Dm755 pforth_standalone $out/bin/pforth
  '';

  meta = {
    homepage = "http://www.softsynth.com/pforth/";
    description = "Portable Portable ANS-like Forth written in ANSI 'C'";
    changelog = "https://github.com/philburk/pforth/blob/v${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ AndersonTorres yrashk ];
    platforms = lib.platforms.unix;
  };
})
# TODO: option for install the non-standalone executable
