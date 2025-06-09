{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  autoreconfHook,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "fplll";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "sha256-WvjXaCnUMioSmLlWmLV673mhRjnF+8DU9MqgUmBgaFQ=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    autoreconfHook
  ];

  buildInputs = [
    gmp
    mpfr
  ];

  meta = with lib; {
    description = "Lattice algorithms using floating-point arithmetic";
    changelog = [
      # Some release notes are added to the github tags, though they are not
      # always complete.
      "https://github.com/fplll/fplll/releases/tag/${version}"
      # Releases are announced on this mailing list. Unfortunately it is not
      # possible to generate a direct link to the most recent announcement, but
      # this search should find it.
      "https://groups.google.com/forum/#!searchin/fplll-devel/FPLLL$20${version}"
    ];
    license = licenses.lgpl21Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
  };
}
