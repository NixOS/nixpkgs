{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, dnsmasq
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "wifi-connect";
  version = "4.11.23";

  src = fetchFromGitHub {
    owner = "balena-os";
    repo = "wifi-connect";
    rev = "v${version}";
    hash = "sha256-gTOsSajKXVMoY14VyXBR4Sf7yrWhJxBA1qaXMVs9mvU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "network-manager-0.13.3" = "sha256-h9xM9qNsk4Ac6vnkDiKskfry8bWUpK3v8Jne5hdbGs4=";
    };
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  postInstall = ''
    mkdir -p $out/share/${pname}
    mv ui/build $out/share/${pname}/ui
  '';

  fixupPhase = ''
    runHook preFixup
    wrapProgram $out/bin/wifi-connect --prefix PATH : ${lib.makeBinPath [ dnsmasq ]}
    runHook postFixup
  '';

  meta = with lib; {
    description = "Easy WiFi setup for Linux devices from your mobile phone or laptop";
    homepage = "https://github.com/balena-os/wifi-connect";
    changelog = "https://github.com/balena-os/wifi-connect/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "wifi-connect";
  };
}
