{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zlib,
  openssl,
  nixosTests,
}:
buildDotnetModule rec {
  pname = "wasabibackend";
  version = "2.0.2.1";

  src = fetchFromGitHub {
    owner = "zkSNACKs";
    repo = "WalletWasabi";
    tag = "v${version}";
    hash = "sha512-JuCl3SyejzwUd2n8Fy7EdxUuO4bIcGb8yMWZQOhZzsY4fvg9prFOnVZEquxahD0a41MLKHRNA1R2N3NMapcc0A==";
  };

  projectFile = "WalletWasabi.Backend/WalletWasabi.Backend.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_7_0-bin;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0-bin;

  buildInputs = [(lib.getLib stdenv.cc.cc) zlib];

  runtimeDeps = [openssl zlib];

  preConfigure = ''
    makeWrapperArgs+=(
      --chdir "$out/lib/${pname}"
    )
  '';

  postFixup = ''
    mv $out/bin/WalletWasabi.Backend $out/bin/WasabiBackend
  '';

  passthru.tests = {
    inherit (nixosTests) wasabibackend;
  };

  meta = with lib; {
    description = "Backend for the Wasabi Wallet";
    homepage = "https://wasabiwallet.io/";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.mit;
    maintainers = with maintainers; [mmahut];
    platforms = ["x86_64-linux"];
  };
}
