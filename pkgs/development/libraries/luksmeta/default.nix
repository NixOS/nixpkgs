{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, asciidoc
, cryptsetup
}:

stdenv.mkDerivation rec {
  pname = "luksmeta";
  version = "9";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "10nslwk7m1qwskd12c204ipa3cbad0q6fn0v084z2f7q6xxbkd2d";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc ];
  buildInputs = [ cryptsetup ];

  meta = {
    description = "Simple library for storing metadata in the LUKSv1 header";
    homepage = "https://github.com/latchset/luksmeta/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.lgpl21Plus;
  };
}
