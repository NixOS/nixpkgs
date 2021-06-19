{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "erfa";
  version = "1.7.2";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "liberfa";
    repo = "erfa";
    rev = "v${version}";
    sha256 = "sha256-iqCrLRBIHVBnUltUxmehzTG6QDjxLM/twSifSf/mWO8=";
  };

  configureFlags = [ "--enable-shared" ];

  meta = with lib; {
    description = "Essential Routines for Fundamental Astronomy";
    homepage = "https://github.com/liberfa/erfa";
    maintainers = with maintainers; [ mir06 ];
    license = {
      url = "https://github.com/liberfa/erfa/blob/master/LICENSE";
      free = true;
    };
  };
}
