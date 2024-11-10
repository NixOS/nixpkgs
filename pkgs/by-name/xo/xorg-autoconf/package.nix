{ lib
, stdenv
, autoreconfHook
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "xorg-autoconf";
  version = "1.19.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "macros";
    rev = "util-macros-${version}";
    sha256 = "sha256-+yEMCjLztdY5LKTNjfhudDS0fdaOj4LKZ3YL5witFR4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "GNU autoconf macros shared across X.Org projects";
    homepage = "https://gitlab.freedesktop.org/xorg/util/macros";
    maintainers = with maintainers; [ raboof ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
