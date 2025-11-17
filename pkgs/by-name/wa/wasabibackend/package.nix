{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zlib,
  openssl,
  nix-update-script,
  nixosTests,
}:
buildDotnetModule rec {
  pname = "wasabibackend";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "WalletWasabi";
    repo = "WalletWasabi";
    tag = "v${version}";
    hash = "sha256-Fu7nLzrjgj45jVO9ZOZAb6LIL6ljSmDxvDdQEZtIHj0=";
  };

  projectFile = "WalletWasabi.Backend/WalletWasabi.Backend.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  runtimeDeps = [
    openssl
    zlib
  ];

  executables = [ "WalletWasabi.Backend" ];

  postFixup = ''
    mv $out/bin/WalletWasabi.Backend $out/bin/WasabiBackend
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) wasabibackend;
    };
  };

  meta = {
    changelog = "https://github.com/WalletWasabi/WalletWasabi/releases/tag/${src.tag}";
    description = "Backend for the Wasabi Wallet";
    homepage = "https://wasabiwallet.io/";
    license = lib.licenses.mit;
    mainProgram = "WasabiBackend";
    maintainers = with lib.maintainers; [
      mmahut
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # contains binaries in WalletWasabi/Microservices/Binaries
      fromSource
    ];
  };
}
