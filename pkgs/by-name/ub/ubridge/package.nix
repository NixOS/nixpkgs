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
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vo57Yw5E4AdUt9MFlFEcRcDkIDG3aQfISIzsC6E05kk=";
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
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
