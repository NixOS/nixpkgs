{ lib, stdenv
, fetchurl
, autoreconfHook
, pari
, ntl
, gmp
# "FLINT is optional and only used for one part of sparse matrix reduction,
# which is used in the modular symbol code but not mwrank or other elliptic
# curve programs." -- https://github.com/JohnCremona/eclib/blob/master/README
, withFlint ? false, flint ? null
}:

assert withFlint -> flint != null;

stdenv.mkDerivation rec {
  pname = "eclib";
<<<<<<< HEAD
  version = "20230424"; # upgrade might break the sage interface
=======
  version = "20221012"; # upgrade might break the sage interface
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # sage tests to run:
  # src/sage/interfaces/mwrank.py
  # src/sage/libs/eclib
  # ping @timokau for more info
  src = fetchurl {
    # all releases for this project appear on its GitHub releases page
    # by definition! other distros sometimes update whenever they see
    # a version bump in configure.ac or a new tag (and this might show
    # up on repology). however, a version bump or a new tag may not
    # represent a new release, and a new release might not be tagged.
    #
    # see https://github.com/JohnCremona/eclib/issues/64#issuecomment-789788561
    # for upstream's explanation of the above
<<<<<<< HEAD
    url = "https://github.com/JohnCremona/eclib/releases/download/v${version}/eclib-${version}.tar.bz2";
    sha256 = "sha256-FCLez8q+uwrUL39Yxa7+W9j6EXV7ReMaGGOE/QN81cE=";
=======
    url = "https://github.com/JohnCremona/eclib/releases/download/${version}/eclib-${version}.tar.bz2";
    sha256 = "sha256-TPavWyn6BMt7fAo19rrlPICPbK/XKstBruB/ka1adBc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  buildInputs = [
    pari
    ntl
    gmp
  ] ++ lib.optionals withFlint [
    flint
  ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  doCheck = true;
  meta = with lib; {
    description = "Elliptic curve tools";
    homepage = "https://github.com/JohnCremona/eclib";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
