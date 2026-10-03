{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4";
  pname = "txtw";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "txtw";
    rev = finalAttrs.version;
    hash = "sha256-c3ifQ5UIlX42MT8xzl4JSvO/t5nv85CL0w4g0Npr0p8=";
  };

  buildInputs = [ cairo ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Compute text widths";
    homepage = "https://github.com/baskerville/txtw";
    maintainers = with lib.maintainers; [ lihop ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    mainProgram = "txtw";
  };
})
