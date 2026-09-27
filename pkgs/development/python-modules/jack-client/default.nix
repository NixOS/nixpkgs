{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  numpy,
  jack2,
  jack-example-tools,
  libjack2,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jack-client";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "jackclient-python";
    tag = finalAttrs.version;
    hash = "sha256-SqDHFUlAtGbT/UJALykPvdP7+5KUlZkMpwYDjq+rU98=";
  };

  # jack.py uses cffi to bind to libjack, so cffi is needed at runtime.
  # It’s also needed while building the wheel.
  build-system = [
    setuptools
    cffi
  ];

  dependencies = [
    cffi
  ];

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    jack2 # jackd
    jack-example-tools # jack_lsp
  ];

  preCheck = ''
    export JACK_NO_AUDIO_RESERVATION=1
    export JACK_PROMISCUOUS_SERVER=1
    export JACK_DEFAULT_SERVER=nix-build

    cleanup() {
      if [[ -n "''${jackd_pid:-}" ]]; then
        kill -- "$jackd_pid" || true
        wait -- "$jackd_pid" || true
      fi
    }

    trap cleanup EXIT

    # Starting a dummy JACK server for the tests
    jackd --no-realtime -n "$JACK_DEFAULT_SERVER" -d dummy -r 48000 -p 1024 &
    jackd_pid=$!

    # Wait until JACK server is accepting JACK clients.
    for i in {0..1000}; do
      if jack_lsp &>/dev/null; then jackd_started=1; break; fi
      sleep .1s
    done

    if [[ ! -v jackd_started ]]; then
      >&2 echo 'JACK server did not start'
      exit 1
    fi
  '';

  postPatch =
    let
      libjack2LibPath = "${lib.getLib libjack2}/lib/libjack${stdenv.hostPlatform.extensions.sharedLibrary}";
    in
    ''
      substituteInPlace src/jack.py \
        --replace-fail "_find_library('libjack64')" "'${libjack2LibPath}'" \
        --replace-fail "_find_library('libjack')" "'${libjack2LibPath}'" \
        --replace-fail "_find_library('jack')" "'${libjack2LibPath}'"
    '';

  pythonImportsCheck = [
    "jack"
  ];

  meta = {
    description = "JACK Audio Connection Kit client for Python";
    homepage = "https://jackclient-python.readthedocs.io/";
    changelog = "https://jackclient-python.readthedocs.io/en/${finalAttrs.version}/version-history.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.unclechu ];
    # Could just use libjack2.meta.platforms here but dummy JACK server for the
    # tests is failing to start on x86_64-darwin & aarch64-darwin.
    # jack.JackOpenError: Error initializing "MyGreatClient": <jack.Status 0x11: failure, server_failed>
    platforms = lib.platforms.linux;
  };
})
