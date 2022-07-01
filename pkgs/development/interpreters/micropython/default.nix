{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, python3
, libffi
, readline
}:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.18";

  src = fetchFromGitHub {
    owner  = "micropython";
    repo   = "micropython";
    rev    = "v${version}";
    sha256 = "sha256-roskIDyY3ehasOm8Yn4braLNZtaeuItb9ZOUgF4CXww=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libffi readline ];

  buildPhase = ''
    runHook preBuild
    make -C mpy-cross
    make -C ports/unix
    runHook postBuild
  '';

  doCheck = true;

  skippedTests = ""
    + lib.optionalString (stdenv.isDarwin) " -e uasyncio_basic -e uasyncio_heaplock -e uasyncio_wait_task"
    + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) " -e ffi_callback"
    + lib.optionalString (stdenv.isLinux && stdenv.isAarch64) " -e float_parse"
  ;

  checkPhase = ''
    runHook preCheck
    pushd tests
    ${python3.interpreter} ./run-tests.py ${skippedTests}
    popd
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ports/unix/micropython -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak sgo ];
  };
}
