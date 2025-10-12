{
  lib,
  stdenv,
  audiofile,
  libtiff,
  buildPackages,
  fetchpatch,
  autoconf,
  automake,
  fftw,
  libpcap,
  libsndfile,
  libtool,
  libxml2,
  netpbm,
  sox,
  util-linux,
  which,
}:

{
  version,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spandsp";
  inherit version src;

  patches = [
    # submitted upstream: https://github.com/freeswitch/spandsp/pull/47
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/1f810894804d3fa61ab3fc2f3feb0599145a3436.patch";
      hash = "sha256-Cf8aaoriAvchh5cMb75yP2gsZbZaOLha/j5mq3xlkVA=";
    })
  ];

  postPatch = ''
    patchShebangs autogen.sh

    # pkg-config? What's that?
    # Actually *check* the value given for --{en,dis}able-tests, not just whether the option was passed
    substituteInPlace configure.ac \
      --replace-fail '$xml2_include_dir /usr/include /usr/local/include /usr/include/libxml2 /usr/local/include/libxml2' '$xml2_include_dir ${lib.getDev libxml2}/include ${lib.getDev libxml2}/include/libxml2 /usr/local/include/libxml2' \
      --replace-fail 'if test -n "$enable_tests" ; then' 'if test "$enable_tests" = "yes" ; then'
  '';

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    util-linux
    which
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  propagatedBuildInputs = [
    audiofile
    libtiff
  ];

  nativeCheckInputs = [
    libtiff
    netpbm
    sox
  ];

  checkInputs = [
    fftw
    libpcap
    libsndfile
    libxml2
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")

    # This flag is required to prevent linking error in the cross-compilation case.
    # I think it's fair to assume that realloc(NULL, size) will return a valid memory
    # block for most libc implementation, so let's just assume that and hope for the best.
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  # Issues with test asset generation under heavy parallelism
  enableParallelBuilding = false;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/cc"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Missing const conversion on some calls
    "-Wno-error=incompatible-pointer-types"
  ];

  hardeningDisable = lib.optionals (lib.strings.versionOlder finalAttrs.version "3.0.0") [
    "format"
  ];

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # Compat with i.e. Clang improved by 0446f4e0c72553f3ea9b50c5333ece6ac980e58d, too big to apply
    && stdenv.cc.isGNU;

  disabledTests = [
    # Need proprietary recordings that aren't included
    "ademco_contactid_tests"
    "dtmf_rx_tests"
    "g722_tests"
    "g726_tests"
    "gsm0610_tests"
    "modem_connect_tones_tests"
    "sig_tone_tests"
    "t42_tests"
    "t43_tests"
    "v42bis_tests"

    # Fails to initialise modem.
    "data_modems_tests"

    # ERROR PTY Fatal error: failed to create /dev/spandsp/0 symbolic link
    "dummy_modems_tests" # needs extra setup, but eventually runs into the above error
    "pseudo_terminal_tests"

    # Hangs. Maybe needs setup / some interaction
    "fax_tests"

    # Needs an input file, unsure what's suitable
    "playout_tests"

    # Borked in the packaged versions due to missing audio file - copy-pasting mistake
    # Maybe fixed after 5394b2cae6c482ccb835335b769469977e6802ae, but too big to apply
    "super_tone_rx_tests"

    # Stuck
    "t31_pseudo_terminal_tests"

    # Generated signal has more than the expected maximum samples - 441 vs 422
    "time_scale_tests"

    # Test failed - -16dBm0 of noise, signal is 9056.993164 (11440.279297)
    "tone_detect_tests"

    # Fails due to result different from reference
    "v18_tests"

    # Seemingly runs forever, with tons of output
    "v22bis_tests"
  ];

  checkPhase = ''
    runHook preCheck

    pushd tests

    for test in *_tests; do
      testArgs=()
      case "$test" in
        # Skipped tests
        ${lib.strings.concatStringsSep "|" finalAttrs.disabledTests})
          echo "Skipping $test"
          continue
          ;;

        # Needs list of subtests to run
        echo_tests)
          testArgs+=(
            sanity 2a 2b 2ca 3a 3ba 3bb 3c 4 5 6 7 8 9 10a 10b 10c 11 12 13 14 15
          )
          # Fallthough for running the test
          ;;&

        *)
          echo "Running $test"
          if ! ./"$test" "''${testArgs[@]}" >"$test".log 2>&1; then
            echo "$test failed! Output:"
            cat "$test".log
            exit 1
          fi
          ;;
      esac
    done

    popd

    runHook postCheck
  '';

  meta = {
    description = "Portable and modular SIP User-Agent with audio and video support";
    homepage = "https://github.com/freeswitch/spandsp";
    platforms = with lib.platforms; unix;
    maintainers = with lib.maintainers; [ misuzu ];
    teams = [ lib.teams.ngi ];
    license = lib.licenses.gpl2;
    downloadPage = "http://www.soft-switch.org/downloads/spandsp/";
  };
})
