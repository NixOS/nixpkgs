{
  fetchFromGitHub,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "xrock";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = "xrock";
    tag = "v${version}";
    hash = "sha256-4b/Us0UybWL2XQOqwR36TAEUmbx3WOtKi6H9VYetweA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp xrock $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Low-level tooling for working with Rockchip SoCs";
    homepage = "https://github.com/xboot/xrock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = lib.platforms.linux;
    mainProgram = "xrock";
  };
}
