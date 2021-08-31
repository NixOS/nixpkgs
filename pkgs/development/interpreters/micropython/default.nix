{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, pkg-config
, libffi
, python3
, readline
}:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.15";

  src = fetchFromGitHub {
    owner  = "micropython";
    repo   = "micropython";
    rev    = "v${version}";
    sha256 = "11bf1lq4kgfs1nzg5cnshh2dqxyk5w2k816i04innri6fj0g7y6p";
    fetchSubmodules = true;
  };

  # drop the following patches when upgrading to 1.16
  patches = [
    # fix build with modern clang https://github.com/micropython/micropython/pull/7254
    (fetchpatch {
      url = "https://github.com/micropython/micropython/commit/126b1c727118352923703719a2a3d45b9fad3c97.patch";
      sha256 = "13a2bmz24syhd1qsqbx39dcjkjdhf05ln7lanh816m94lkfib21j";
    })
    # fix build with modern clang https://github.com/micropython/micropython/pull/7254
    (fetchpatch {
      url = "https://github.com/micropython/micropython/commit/7ceccad4e2f1e9d073f5781c32e5b377e8391a25.patch";
      sha256 = "04mbxmb5yr6pbhhf9villq8km4wy579r46v9p4n0ysivrxij7i6f";
    })
    # fix build on aarch64-darwin https://github.com/micropython/micropython/pull/7393
    (fetchpatch {
      url = "https://github.com/micropython/micropython/commit/95048129b1d93854c25f501c02801929aeeb23f0.patch";
      sha256 = "1cngcwq4jviyhdnfcrrkdadfikhffzbj0d634j0344cp247jb41n";
    })
  ];

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
    + lib.optionalString (stdenv.isDarwin) " -e uasyncio_basic -e uasyncio_wait_task"
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
    maintainers = with maintainers; [ sgo ];
  };
}
