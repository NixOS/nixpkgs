{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pe-parse,
  uthenticode,
  openssl,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "winchecksec";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "winchecksec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KK0mQiPY/LNCcY4z1smpRjzyLhVcpm/k2ReCUB2hq1Y=";
  };

  checkInputs = [ gtest ];

  buildInputs = [
    cmake
    openssl

    pe-parse
    uthenticode
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace 'if (BUILD_TESTS)' $'find_package(GTest CONFIG REQUIRED)\nadd_subdirectory(test)\nif (FALSE)'
  '';

  doCheck = true;
  checkPhase = "test/winchecksec_test";

  installPhase = ''
    runHook preInstall

    install -Dm555 winchecksec $out/bin/winchecksec

    runHook postInstall
  '';

  meta = {
    homepage = "https://trailofbits.github.io/winchecksec/";
    description = "Check security features of Windows executables";
    mainProgram = "winchecksec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ feyorsh ];
    platforms = lib.platforms.unix;
  };
})
