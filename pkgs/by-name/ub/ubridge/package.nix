{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  testers,
  ubridge,
}:

stdenv.mkDerivation rec {
  pname = "ubridge";
  version = "0.9.19";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "refs/tags/v${version}";
    hash = "sha256-utzXLPF0VszMZORoik5/0lKhiyKO9heKuNO4KPsPVsI=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/local/bin" "$out/bin" \
      --replace-fail "setcap" "#setcap"
  '';

  buildInputs = [ libpcap ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 ubridge $out/bin/ubridge

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ubridge;
      command = "ubridge -v";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Bridge for UDP tunnels, Ethernet, TAP, and VMnet interfaces";
    longDescription = ''
      uBridge is a simple application to create user-land bridges between
      various technologies. Currently bridging between UDP tunnels, Ethernet
      and TAP interfaces is supported. Packet capture is also supported.
    '';
    homepage = "https://github.com/GNS3/ubridge";
    changelog = "https://github.com/GNS3/ubridge/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    mainProgram = "ubridge";
    maintainers = with maintainers; [
      primeos
      anthonyroussel
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
