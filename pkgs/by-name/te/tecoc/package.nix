{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecoc";
  version = "0-unstable-2023-06-21";

  src = fetchFromGitHub {
    owner = "blakemcbride";
    repo = "TECOC";
    rev = "b4a96395a18c7e64ccaef0e25fdde3b7ef33ac4b";
    hash = "sha256-KTOGsTtxJh2sneU2VoDNUHcL3m8zt+3rBZTDvK1n02A=";
  };

  buildInputs = [ ncurses ];

  makefile =
    if stdenv.hostPlatform.isDarwin then
      "makefile.osx"
    else if stdenv.hostPlatform.isFreeBSD then
      "makefile.bsd"
    else if stdenv.hostPlatform.isOpenBSD then
      "makefile.bsd"
    else if stdenv.hostPlatform.isWindows then
      "makefile.win"
    else
      "makefile.linux"; # I think Linux is a safe default...

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "-C src/"
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/doc/tecoc $out/lib/teco/macros
    install -m755 src/tecoc $out/bin
    install -m644 src/aaout.txt doc/* $out/share/doc/tecoc
    install -m644 lib/* lib2/* $out/lib/teco/macros

    runHook postInstall
  '';

  postFixup = ''
    pushd $out/bin
    ln -s tecoc Make
    ln -s tecoc mung
    ln -s tecoc teco
    ln -s tecoc Inspect
    popd
  '';

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.meta.homepage;
  };

  meta = {
    homepage = "https://github.com/blakemcbride/TECOC";
    description = "Clone of the good old TECO editor";
    longDescription = ''
      For those who don't know: TECO is the acronym of Tape Editor and COrrector
      (because it was a paper tape edition tool in its debut days). Now the
      acronym follows after Text Editor and Corrector, or Text Editor
      Character-Oriented.

      TECO is a character-oriented text editor, originally developed by Dan
      Murphy at MIT circa 1962. It is also a Turing-complete imperative
      interpreted programming language for text manipulation, done via
      user-loaded sets of macros. In fact, the venerable Emacs was born as a set
      of Editor MACroS for TECO.

      TECOC is a portable C implementation of TECO-11.
    '';
    license = {
      url = "https://github.com/blakemcbride/TECOC/blob/${finalAttrs.src.rev}/doc/readme-1st.txt";
    };
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
