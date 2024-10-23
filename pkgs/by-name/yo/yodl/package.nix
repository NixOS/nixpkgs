{
  lib,
  fetchFromGitLab,
  icmake,
  perl,
  stdenv,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yodl";
  version = "4.03.03";

  src = fetchFromGitLab {
    owner = "fbb-git";
    repo = "yodl";
    rev = finalAttrs.version;
    hash = "sha256-MeD/jjhwoiWTb/G8pHrnEEX22h+entPr9MhJ6WHO3DM=";
  };

  nativeBuildInputs = [
    icmake
    perl
  ];

  sourceRoot = "${finalAttrs.src.name}/yodl";

  # Set TERM because icmbuild calls tput.
  env.TERM = "xterm";

  strictDeps = true;

  postPatch = ''
    patchShebangs ./build ./scripts/
    substituteInPlace INSTALL.im \
      --replace "/usr" "$out"
    substituteInPlace macros/rawmacros/startdoc.pl \
      --replace "/usr/bin/perl" "${lib.getExe perl}"
    substituteInPlace scripts/yodl2whatever.in \
      --replace "getopt" "${lib.getExe' util-linux "getopt"}"
  '';

  buildPhase = ''
    runHook preBuild

    ./build programs
    ./build macros
    ./build man

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./build install programs
    ./build install macros
    ./build install man

    runHook postInstall
  '';

  meta = {
    homepage = "https://fbb-git.gitlab.io/yodl/";
    description = "Pre-document language and tools to process it";
    longDescription = ''
      Yodl implements a pre-document language and tools to process it. The idea
      behind Yodl is that you write up a document in a pre-language, then use
      the tools (e.g. yodl2html(1)) to convert it to some final document
      language. Current converters are for HTML, man, LaTeX, text and a (very)
      experimental xml converter. Main document types are "article", "report",
      "book" "manpage" and "letter". The Yodl document language was designed to
      be easy to use as well as extensible.
    '';
    license = lib.licenses.agpl3Plus;
    mainProgram = "yodl";
    maintainers = with lib.maintainers; [
      pSub
      AndersonTorres
    ];
    platforms = lib.platforms.all;
  };
})
