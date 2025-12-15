{
  lib,
  stdenv,
  fetchFromGitLab,
  perl,
  icmake,
  util-linux,
  bash,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yodl";
  version = "4.05.00";

  src = fetchFromGitLab {
    owner = "fbb-git";
    repo = "yodl";
    tag = finalAttrs.version;
    hash = "sha256-QnEjMHuZHj+iPlmiPsAcaNF8RRd/Ld59PA1neuzo1Go=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */yodl)
  '';

  postPatch = ''
    for header in media/media.h stack/stack.h message/message.h symbol/symbol.ih symbol/sysp.c hashitem/hashitem.h args/args.h ostream/ostream.h; do
      sed -i '1i#include <stdbool.h>' "$header"
    done
    patchShebangs ./build
    patchShebangs scripts/
    substituteInPlace INSTALL.im \
      --replace-fail "/usr" "$out"
    substituteInPlace macros/rawmacros/startdoc.pl \
      --replace-fail "/usr/bin/perl" "${lib.getExe perl}"
    substituteInPlace scripts/yodl2whatever.in \
      --replace-fail "getopt" "${lib.getExe' util-linux "getopt"}"
    substituteInPlace icmake/stdcpp \
      --replace-fail "printf << \"    \" << file << '\n';" 'printf("    " + file + "\n");'
  '';

  nativeBuildInputs = [
    icmake
    perl
    bash
  ];

  # Set TERM because icmbuild calls tput.
  env.TERM = "xterm";

  buildPhase = ''
    runHook preBuild

    CXXFLAGS+=' --std=c++20'
    export CXXFLAGS
    ./build programs
    ./build macros
    ./build man
    ./build html

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./build install programs
    ./build install macros
    ./build install man
    # dangling symlinks
    rm $out/share/man/man1/yodl2xml.1
    rm $out/share/man/man1/yodl2txt.1
    rm $out/share/man/man1/yodl2man.1
    rm $out/share/man/man1/yodl2latex.1
    rm $out/share/man/man1/yodl2html.1
    rm $out/share/man/man1/yodl2whatever.1
    ./build install manual

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://gitlab.com/fbb-git/yodl/-/blob/${finalAttrs.src.tag}/yodl/changelog";
    description = "Package that implements a pre-document language and tools to process it";
    homepage = "https://fbb-git.gitlab.io/yodl/";
    mainProgram = "yodl";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
