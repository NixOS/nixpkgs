{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  python3,
  libffi,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "v${version}";
    sha256 = "sha256-sdok17HvKub/sI+8cAIIDaLD/3mu8yXXqrTOej8/UfU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    libffi
    readline
  ];

  buildPhase = ''
    runHook preBuild
    make -C mpy-cross
    make -C ports/unix
    runHook postBuild
  '';

  doCheck = true;

  skippedTests =
    " -e select_poll_fd"
    + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) " -e ffi_callback"
    + lib.optionalString (stdenv.isLinux && stdenv.isAarch64) " -e float_parse";

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
    description = "A lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [
      prusnak
      sgo
    ];
  };
}
