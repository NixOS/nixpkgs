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
    hash = "sha256-coUFIepbCRuz+766E7VCTQLm0oWB1CTO20ATriC86dc=";
    fetchSubmodules = true;

    # remove unused libaries from rp2 port's SDK. we leave this and the other
    # ports around for users who want to override makeFlags flags to build them.
    # https://github.com/micropython/micropython/blob/a61c446c0b34e82aeb54b9770250d267656f2b7f/ports/rp2/CMakeLists.txt#L17-L22
    #
    # shrinks uncompressed NAR by ~2.4G (though it is still large). there
    # doesn't seem to be a way to avoid fetching them in the first place.
    postFetch = ''
      rm -rf $out/lib/pico-sdk/lib/{tinyusb,lwip,btstack}
    '';
  };


  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libffi readline ];

  makeFlags = [ "-C" "ports/unix" ]; # also builds mpy-cross

  enableParallelBuilding = true;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # needed for select_poll_eintr test

  skippedTests = " -e select_poll_fd"
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) " -e ffi_callback -e float_parse -e float_parse_doubleproc"
    + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) " -e float_parse"
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
