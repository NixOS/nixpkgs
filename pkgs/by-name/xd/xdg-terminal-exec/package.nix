{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  dash,
  scdoc,
  makeBinaryWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xdg-terminal-exec";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "xdg-terminal-exec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RgyXdrJEiPXOHpnUUuu7UVNC+RE36WgyXuuDgA8H1EQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    scdoc
    makeBinaryWrapper
  ];

  buildInputs = [ dash ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  dontPatchShebangs = true;
  postFixup = ''
    # use dash posix sh implementation as recommended by upstream
    substituteInPlace $out/bin/xdg-terminal-exec \
      --replace-fail '#!/bin/sh' '#!${lib.getExe dash}'

    # add default config to XDG_DATA_DIRS
    wrapProgram $out/bin/xdg-terminal-exec \
      --suffix XDG_DATA_DIRS : '${placeholder "out"}/share'
  '';

  meta = {
    description = "Reference implementation of the proposed XDG Default Terminal Execution Specification";
    homepage = "https://github.com/Vladimir-csp/xdg-terminal-exec";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xdg-terminal-exec";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.unix;
  };
})
