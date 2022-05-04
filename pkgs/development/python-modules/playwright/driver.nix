{ stdenv
, fetchurl
, playwrightVersion
}:

let
  inherit (stdenv.hostPlatform) system;
  selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
  suffix = selectSystem {
    x86_64-linux = "linux";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "mac";
    aarch64-darwin = "mac-arm64";
  };
  sha256 = selectSystem {
    x86_64-linux = "sha256-RyTYrIBMIFuIfr/WRH+qXf3DcQvEDLBePD1PeKzY93c=";
    aarch64-linux = "sha256-u5OtIVygcVQALqxWO/bEhf7jaGC6PtY/1sqrb5GH/kM=";
    x86_64-darwin = "sha256-KTg4nt/MZL7PzBCsU0Y9Pq9j2QEbG3iOdhWdC66romQ=";
    aarch64-darwin = "sha256-xdrWn+fZC0QbUe3uCqWErtTaSKWOIwp+0zLLSFXnA/A=";
  };
in
fetchurl {
  name = "playwright-driver";
  url = "https://playwright.azureedge.net/builds/driver/playwright-${playwrightVersion}-${suffix}.zip";
  inherit sha256;
  recursiveHash = true;
  downloadToTemp = true;
  postFetch = ''
    mkdir -p $out/driver/
    install "$downloadedFile" $out/driver/playwright-${playwrightVersion}-${suffix}.zip
  '';
}
