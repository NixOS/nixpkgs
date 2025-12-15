{
  lib,
  resholve,
  fetchFromGitHub,

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
  version = "0.4.1";
  gvproxyWin = gvproxy.overrideAttrs (_: {
    buildPhase = ''
      GOARCH=amd64 GOOS=windows go build -ldflags '-s -w' -o bin/gvproxy-windows.exe ./cmd/gvproxy
    '';
  });
in
resholve.mkDerivation {
  pname = "wsl-vpnkit";
  inherit version;

  src = fetchFromGitHub {
    owner = "sakai135";
    repo = "wsl-vpnkit";
    tag = "v${version}";
    hash = "sha256-Igbr3L2W32s4uBepllSz07bkbI3qwAKMZkBrXLqGrGA=";
  };

  postPatch = ''
    substituteInPlace wsl-vpnkit \
      --replace "/app/wsl-vm" "${gvproxy}/bin/gvforwarder" \
      --replace "/app/wsl-gvproxy.exe" "${gvproxyWin}/bin/gvproxy-windows.exe"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp wsl-vpnkit $out/bin
  '';

  solutions.wsl-vpnkit = {
    scripts = [ "bin/wsl-vpnkit" ];
    interpreter = "none";
    inputs = [
      coreutils
      dnsutils
      gawk
      gnugrep
      iproute2
      iptables
      iputils
      wget
    ];

    keep = {
      "$VMEXEC_PATH" = true;
      "$GVPROXY_PATH" = true;
    };

    execer = [
      "cannot:${iproute2}/bin/ip"
      "cannot:${wget}/bin/wget"
    ];

    fix = {
      aliases = true;
      ping = "${iputils}/bin/ping";
    };
  };

  meta = {
    description = "Provides network connectivity to Windows Subsystem for Linux (WSL) when blocked by VPN";
    homepage = "https://github.com/sakai135/wsl-vpnkit";
    changelog = "https://github.com/sakai135/wsl-vpnkit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ terlar ];
    mainProgram = "wsl-vpnkit";
  };
}
