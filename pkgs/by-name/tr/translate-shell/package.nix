{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  fribidi,
  rlwrap,
  gawk,
  groff,
  ncurses,
  hexdump,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "translate-shell";
  version = "0.9.7.1";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ILXE8cSrivYqMruE+xtNIInLdwdRfMX5dneY9Nn12Uk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/trans \
      --prefix PATH : ${
        lib.makeBinPath [
          gawk
          curl
          ncurses
          rlwrap
          groff
          fribidi
          hexdump
        ]
      }
  '';

  meta = {
    homepage = "https://www.soimort.org/translate-shell";
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium";
    license = lib.licenses.unlicense;
    mainProgram = "trans";
    platforms = lib.platforms.unix;
  };
})
