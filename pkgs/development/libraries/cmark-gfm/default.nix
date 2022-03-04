{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cmark-gfm";
  version = "0.29.0.gfm.3";

  src = fetchFromGitHub {
    owner = "github";
    repo = "cmark-gfm";
    rev = version;
    sha256 = "sha256-V3XegSjqKLCMpfnoYHr9/r5fSC2CC7A2jXkAcHUt7eA=";
  };

  nativeBuildInputs = [ cmake ];
  # tests load the library dynamically which for unknown reason failed
  doCheck = false;

  # remove when https://github.com/github/cmark-gfm/pull/248 merged and released
  postInstall = ''
    substituteInPlace $out/include/cmark-gfm-core-extensions.h \
    --replace '#include "config.h"' '#include <stdbool.h>'
  '';

  meta = with lib; {
    description = "GitHub's fork of cmark, a CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/github/cmark-gfm";
    maintainers = with maintainers; [ cyplo ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
