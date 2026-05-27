{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_14,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zetui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zexk";
    repo = "zetui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D5vpMUZAhIUMO3xvm3mlqy4Ky0VzTxeVX85y+w7vzpY=";
  };

  nativeBuildInputs = [ zig_0_14.hook ];

  meta = {
    description = "ANSI/C89 single-header TUI library with first-class Zig bindings";
    homepage = "https://github.com/zexk/zetui";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ zexk ];
    platforms = lib.platforms.unix;
  };
})
