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
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "v${version}";
    hash = "sha256-sfJohmsqq5FumUoVE8x3yWv12DiCJJXae62br0j+190=";
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

  skippedTests = " -e select_poll_fd"
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
    install -Dm755 ports/unix/build-standard/micropython -t $out/bin
    install -Dm755 mpy-cross/build/mpy-cross -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak sgo ];
  };
}
