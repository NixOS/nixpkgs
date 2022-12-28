{ callPackage }:
callPackage ./binary.nix {
  version = "1.25.0";
  hashes = {
    # Get these from `nix-prefetch-url https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz` etc..
    osx-x86_64 = "sha256-6iKnbS+oalLKmyS8qYD/wS21b7+O+VgsWG2iT4PrWPU=";
    linux-x86_64 = "sha256-sfg47RdlsIpryc3iZvE17OtLweh3Zw6DeuNJYgpuH+o=";
    linux-aarch64  = "sha256-UDZ43x4flSo+SfsPeE8juZO2Wtk2ZzwySk0ADHnvJBI=";
    osx-arm64  = "sha256-O/x0vy0wwQFaDc4uWSeMhx+chJKqbQb6e5QNYf+7DCw=";
  };
}
