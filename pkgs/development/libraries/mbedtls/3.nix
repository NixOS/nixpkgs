{ callPackage, fetchpatch }:

callPackage ./generic.nix {
  version = "3.4.0";
  hash = "sha256-1YA4hp/VEjph5k0qJqhhH4nBbTP3Qu2pl7WpuvPkVfg=";
  patches = [
    ./3.4.0-CVE-2023-45199.patch
    (fetchpatch {
      name = "CVE-2023-43615.patch";
      url = "https://github.com/Mbed-TLS/mbedtls/commit/faf0b8604ac49456b0cff7a34ad27485ca145cce.patch";
      hash = "sha256-GFx+7TmhthRbwBnTgTdNhokftsGwIY7cQGhxKf3WZcE=";
    })
  ];
}
