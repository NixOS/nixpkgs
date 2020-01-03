{ stdenv
, fetchFromGitHub
, fetchpatch
, gettext
, autoreconfHook
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "fplll";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "1bzlqavbch5smra75znh4ljr490wyx5v6hax8r9rjbgk605i33ns";
  };

  nativeBuildInputs = [
    gettext
    autoreconfHook
  ];

  buildInputs = [
    gmp
    mpfr
  ];

  meta = with stdenv.lib; {
    description = ''Lattice algorithms using floating-point arithmetic'';
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
    maintainers = with maintainers; [raskin timokau];
    platforms = platforms.unix;
  };
}
