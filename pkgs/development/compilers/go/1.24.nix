{
  stdenvNoCC,
  fetchurl,
  buildPackages,
  buildGo124Module,
}:

let
  goPlatform =
    with stdenvNoCC.hostPlatform.go;
    "${GOOS}-${if GOARCH == "arm" then "armv6l" else GOARCH}";
  # Bootstrap from source on platforms that support it(not Darwin, FreeBSD, or Loongarch64)
  bootstrap =
    if
      (
        !stdenvNoCC.hostPlatform.isDarwin
        && !stdenvNoCC.hostPlatform.isFreeBSD
        && goPlatform != "linux-loong64"
      )
    then
      buildPackages.callPackage ./1.22.nix { }
    else
      buildPackages.callPackage ./bootstrap122.nix { };

  version = "1.24.6";
in
buildPackages.callPackage ./generic.nix {
  inherit bootstrap version;
  buildGoModule = buildGo124Module;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-4ctVgqq1iGaLwEwH3hhogHD2uMmyqvNh+CHhm9R8/b0=";
  };
}
