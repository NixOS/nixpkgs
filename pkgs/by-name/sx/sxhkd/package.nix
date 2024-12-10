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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxhkd";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = finalAttrs.version;
    hash = "sha256-OelMqenk0tiWMLraekS/ggGf6IsXP7Sz7bv75NvnNvI=";
  };

  patches = [
    (fetchpatch {
      # Fixes an issue with overlapping chords when using multiple keyboard layouts.
      name = "sxhkd-mod5.patch";
      url = "https://github.com/baskerville/sxhkd/pull/307/commits/35e64f1d7b54c97ccc02e84e278012dae9bc3941.patch";
      hash = "sha256-bvXWEEITbHC/h0nXQx99SXjvkI/KO36XXNSa1O8KSY0=";
    })
  ];

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

  meta = {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = lib.licenses.bsd2;
    mainProgram = "sxhkd";
    maintainers = with lib.maintainers; [
      vyp
      AndersonTorres
      ncfavier
    ];
    inherit (libxcb.meta) platforms;
  };
})
