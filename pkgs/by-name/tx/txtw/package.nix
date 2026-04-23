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
    sha256 = "17yjdgdd080fsf5r1wzgk6vvzwsa15gcwc9z64v7x588jm1ryy3k";
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
