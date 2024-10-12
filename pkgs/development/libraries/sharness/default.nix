{ stdenv
, lib
, fetchFromGitHub
, perl
, perlPackages
, sharnessExtensions ? {} }:

stdenv.mkDerivation (finalAttrs: {
  pname = "sharness";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "felipec";
    repo = "sharness";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C0HVWgTm9iXDSFyXcUVRfT0ip31YGaaZ6ZvxggK/x7o=";
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

  passthru.SHARNESS_TEST_SRCDIR = finalAttrs.finalPackage + "/share/sharness";

  meta = with lib; {
    description = "Portable shell library to write, run and analyze automated tests adhering to Test Anything Protocol (TAP)";
    homepage = "https://github.com/chriscool/sharness";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.spacefrogg ];
    platforms = platforms.unix;
  };
})
