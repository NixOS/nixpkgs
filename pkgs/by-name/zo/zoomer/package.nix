{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zoomer";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "naderhaj";
    repo = "zoomer-mac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q6eHMYIieViUNCZpG2Njcbomo2y78zNTzgoi5u1LYdQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ darwin.sigtool ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Tiny screen magnifier for macOS, zooming toward the cursor with a scroll shortcut";
    homepage = "https://github.com/naderhaj/zoomer-mac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naderhaj ];
    mainProgram = "zoomer";
    platforms = [ "aarch64-darwin" ];
  };
})
