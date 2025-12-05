{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  asciidoc,
  libxcb,
  xcbutil,
  xcbutilkeysyms,
  xcbutilwm,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxhkd";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = finalAttrs.version;
    hash = "sha256-kbjbTzYL2dz/RpG+SgBYy+XS3W9PBEWkg6ocqAFG3VQ=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    asciidoc
  ];

  buildInputs = [
    libxcb
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  strictDeps = true;

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests = {
    inherit (nixosTests) startx;
  };

  meta = {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = lib.licenses.bsd2;
    mainProgram = "sxhkd";
    maintainers = with lib.maintainers; [
      ncfavier
    ];
    inherit (libxcb.meta) platforms;
  };
})
