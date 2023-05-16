{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, perl
, perlPackages
, sharnessExtensions ? {} }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "sharness";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "felipec";
    repo = "sharness";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C0HVWgTm9iXDSFyXcUVRfT0ip31YGaaZ6ZvxggK/x7o=";
=======
stdenv.mkDerivation rec {
  pname = "sharness";
  version = "1.1.0-dev";

  src = fetchFromGitHub {
    owner = "chriscool";
    repo = pname;
    rev = "3f238a740156dd2082f4bd60ced205e05894d367"; # 2020-12-09
    sha256 = "FCYskpIqkrpNaWCi2LkhEkiow4/rXLe+lfEWNUthLUg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Used for testing
  nativeBuildInputs = [ perl perlPackages.IOTty ];

  outputs = [ "out" "doc" ];

  makeFlags = [ "prefix=$(out)" ];

  extensions = lib.mapAttrsToList (k: v: "${k}.sh ${v}") sharnessExtensions;

  postInstall = lib.optionalString (sharnessExtensions != {}) ''
    extDir=$out/share/sharness/sharness.d
    mkdir -p "$extDir"
    linkExtensions() {
      set -- $extensions
      while [ $# -ge 2 ]; do
        ln -s "$2" "$extDir/$1"
        shift 2
      done
    }
    linkExtensions
  '';

  doCheck = true;

<<<<<<< HEAD
  passthru.SHARNESS_TEST_SRCDIR = finalAttrs.finalPackage + "/share/sharness";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Portable shell library to write, run and analyze automated tests adhering to Test Anything Protocol (TAP)";
    homepage = "https://github.com/chriscool/sharness";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.spacefrogg ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
