{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  gettext,
  autoreconfHook,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "fplll";
  version = "5.4.5";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "sha256-taSS7jpVyjVfNe6kSuUDXMD2PgKmtG64V5MjZyQzorI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/fplll/fplll/commit/317cf70893eebfb2625da12e5377189908c36240.diff";
      sha256 = "sha256-GbYSolBgv/he4QzjuRFdg93wHJABVHvA9x3PjpJTSRE=";
    })
  ];

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
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
