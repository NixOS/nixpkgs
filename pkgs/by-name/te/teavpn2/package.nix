{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  iproute2,
}:
stdenv.mkDerivation {
  pname = "teavpn2";
  version = "unstable-2023-07-25";

  src = fetchFromGitHub {
    owner = "TeaInside";
    repo = "teavpn2";
    rev = "b21898d001a2e7b821e045162dd18f13561cb04b";
    hash = "sha256-0/eHK2/+pn6NfawL1xLJv4jDBFvLwELSXNWLUvff1gs=";
  };

  patches = [
    (substituteAll {
      src = ./nix.patch;
      inherit iproute2;
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 teavpn2 $out/bin/teavpn2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source VPN Software";
    homepage = "https://github.com/TeaInside/teavpn2";
    license = licenses.gpl2Plus;
    mainProgram = "teavpn2";
    maintainers = with maintainers; [ ludovicopiero ];
    platforms = platforms.linux;
  };
}
