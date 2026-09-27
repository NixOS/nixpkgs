{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  sqlite,
  pkg-config,
  systemd,
  versionCheckHook,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhub";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "janvidar";
    repo = "uhub";
    rev = finalAttrs.version;
    hash = "sha256-TXE8/qBKeG/mQVydzus5ok8WnAOP+GoNavjgMslvYrI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
  ];
  buildInputs = [
    openssl
    sqlite
    systemd
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/uhub/" "$out/plugins" \
      --replace-fail "/etc/uhub" "$out/share/doc/uhub"
  '';

  cmakeFlags = [
    "-DSYSTEMD_SUPPORT=ON"
  ];

  # run generated autotest-bin for integration-testing
  # skipped tests: fuzzing + stress tests
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./autotest-bin
    runHook postCheck
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    description = "High performance peer-to-peer hub for the ADC network";
    homepage = "https://www.uhub.org/";
    changelog = "https://github.com/janvidar/uhub/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "uhub";
  };
})
