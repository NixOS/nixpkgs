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
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "00iyz218ywspizjiimrjdcqvdqmrsb2367zyy3vkmypnf9i9l680";
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
