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
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = version;
    sha256 = "0wxa4xs7as7y47h7i6prmk5r0srabdvrlkvza3j50pixir5swgvh";
  };

  patches = [
    # https://github.com/fplll/fpylll/issues/161
    (fetchpatch {
      name = "fix-out-of-bounds-access.patch";
      url = "https://github.com/fplll/fplll/pull/398/commits/f68e257228bf073ef380f996326d02197ce7b0e4.patch";
      sha256 = "1rapkcf389lf579va6kbnvhzyv36n4l4d9n0vg2zxprvql8wvm7m";
    })
  ];

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
