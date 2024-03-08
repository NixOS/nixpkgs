{ lib
, stdenv
, fetchFromGitea
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.12.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grisha";
    repo = "gumbo-parser";
    rev = version;
    hash = "sha256-d4V4bI08Prmg3U0KGu4yIwpHcvTJT3NAd4lbzdBU/AE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "C99 HTML parsing algorithm";
    homepage = "https://github.com/google/gumbo-parser";
    maintainers = [ maintainers.nico202 ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
  };
}
