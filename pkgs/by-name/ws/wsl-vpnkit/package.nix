{
  lib,
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,

  # Runtime dependencies
  coreutils,
  dnsutils,
  gawk,
  gnugrep,
  gvproxy,
  iproute2,
  iptables,
  iputils,
  wget,
}:

let
  gvproxyWin = gvproxy.overrideAttrs (_: {
    buildPhase = ''
      GOARCH=amd64 GOOS=windows go build -ldflags '-s -w' -o bin/gvproxy-windows.exe ./cmd/gvproxy
    '';
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wsl-vpnkit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sakai135";
    repo = "wsl-vpnkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Igbr3L2W32s4uBepllSz07bkbI3qwAKMZkBrXLqGrGA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace wsl-vpnkit \
      --replace-fail "/app/wsl-vm" "${gvproxy}/bin/gvforwarder" \
      --replace-fail "/app/wsl-gvproxy.exe" "${gvproxyWin}/bin/gvproxy-windows.exe"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 0755 wsl-vpnkit $out/bin/wsl-vpnkit

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/wsl-vpnkit \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          dnsutils
          gawk
          gnugrep
          iproute2
          iptables
          iputils
          wget
        ]
      }
  '';

  meta = {
    description = "Provides network connectivity to Windows Subsystem for Linux (WSL) when blocked by VPN";
    homepage = "https://github.com/sakai135/wsl-vpnkit";
    changelog = "https://github.com/sakai135/wsl-vpnkit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ terlar ];
    mainProgram = "wsl-vpnkit";
  };
})
