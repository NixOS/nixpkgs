{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  runCommand,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ykushcmd";
  version = "1.4.0";

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "yepkit";
    repo = "ykush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+ssr1QHKjEdK8pFkmyHYwG9tY7YHaYcIIJUqaEXixOg=";
  };

  installPhase = ''
    runHook preInstall

    install -D bin/ykushcmd $out/bin/ykushcmd
    install -Dm444 ${./99-ykush.rules} $out/lib/udev/rules.d/99_ykush.rules

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = {
    # We can't run any actual tests without hardware, but we can at least check the binary.
    run-only = runCommand "${finalAttrs.pname}-test" ''
      ${finalAttrs}/bin/ykushcmd -h | grep YKUSHCMD
    '';
  };

  meta = {
    description = "Control utility for YepKit USB hubs";
    longDescription = ''
      controls the features of YepKit USB hubs, allowing one to arbitrarily
      turn ports on and off and otherwise control the hub.
    '';
    homepage = "https://github.com/Yepkit/ykush";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aiyion
      ktemkin
    ];
    mainProgram = "ykushcmd";
    platforms = lib.platforms.linux;
  };
})
