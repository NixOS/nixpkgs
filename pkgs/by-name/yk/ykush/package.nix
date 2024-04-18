{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  runCommand,
  gcc,
}:
stdenv.mkDerivation (final: {
  pname = "ykushcmd";
  version = "1.3.0";

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ gcc ];

  src = fetchFromGitHub {
    owner = "yepkit";
    repo = "ykush";
    rev = "v${final.version}";
    hash = "sha256-ykZAuHk3zPiH20yMYPgq6kJv1LAhUko6jJfAqGREvWA=";
  };

  installPhase = ''
    runHook preInstall

    install -D bin/ykushcmd $out/bin/ykushcmd
    install -Dm444 ${./99-ykush.rules} $out/lib/udev/rules.d/99_ykush.rules

    runHook postInstall
  '';

  passthru.tests = {
    # We can't run any actual tests without hardware, but we can at least check the binary.
    run-only = runCommand "${final.pname}-test" ''
      ${final}/bin/ykushcmd -h | grep YKUSHCMD
    '';
  };

  meta = {
    description = "Control utility for YepKit USB hubs.";
    longDescription = ''
      contols the features of YepKit USB hubs, allowing one to arbitrarily
      turn ports on and off and otherwise control the hub.
    '';
    homepage = "https://github.com/Yepkit/ykush";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ktemkin ];
    mainProgram = "ykushcmd";
  };
})
