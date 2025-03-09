{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
}:

stdenv.mkDerivation rec {
  version = "0.4";
  pname = "txtw";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "txtw";
    rev = version;
    sha256 = "17yjdgdd080fsf5r1wzgk6vvzwsa15gcwc9z64v7x588jm1ryy3k";
  };

  buildInputs = [ cairo ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with lib; {
    description = "Compute text widths";
    homepage = "https://github.com/baskerville/txtw";
    maintainers = with maintainers; [ lihop ];
    license = licenses.unlicense;
    platforms = platforms.linux;
    mainProgram = "txtw";
  };
}
