{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, autoreconfHook
, libmd
, gitUpdater
}:

# Run `./get-version` for the new value when bumping the Git revision.
let gitVersion = "0.11.7-55-g73b2"; in

stdenv.mkDerivation {
  pname = "libbsd";
  version = "unstable-2023-04-29";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libbsd";
    repo = "libbsd";
    rev = "73b25a8f871b3a20f6ff76679358540f95d7dbfd";
    hash = "sha256-LS28taIMjRCl6xqg75eYOIrTDl8PzSa+OvrdiEOP1+U=";
  };

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libmd ];

  patches = [
    # Fix `{get,set}progname(3bsd)` conditionalization
    # https://gitlab.freedesktop.org/libbsd/libbsd/-/issues/24
    (fetchpatch {
      url = "https://github.com/emilazy/libbsd/commit/0381f8d92873c5a19ced3ff861ee8ffe7825953e.patch";
      hash = "sha256-+RMg5eHLgC4gyX9zXM0ttNf7rd9E3UzJX/7UVCYGXx4=";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # Temporary build system hack from upstream maintainer
    # https://gitlab.freedesktop.org/libbsd/libbsd/-/issues/19#note_2017684
    ./darwin-fix-libbsd.sym.patch
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'm4_esyscmd([./get-version])' '[${gitVersion}]'
  '';

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://gitlab.freedesktop.org/libbsd/libbsd.git";
  };

  meta = with lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = with licenses; [ beerware bsd2 bsd3 bsdOriginal isc mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
