/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `../tectonic/package.nix`, by wrapping
  - [`tectonic-unwrapped`](./package.nix) i.e. this package, and
  - [`biber-for-tectonic`](../../bi/biber-for-tectonic/package.nix),
    which provides a compatible version of `biber`.
*/

{
  lib,
  clangStdenv,
  fetchFromGitHub,
  rustPlatform,
  fontconfig,
  harfbuzzFull,
  openssl,
  pkg-config,
  icu,
  fetchpatch2,
}:

let

  buildRustPackage = rustPlatform.buildRustPackage.override {
    # use clang to work around build failure with GCC 14
    # see: https://github.com/tectonic-typesetting/tectonic/issues/1263
    stdenv = clangStdenv;
  };

in

buildRustPackage rec {
  pname = "tectonic";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "sha256-dZnUu0g86WJIIvwMgdmwb6oYqItxoYrGQTFNX7I61Bs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/tectonic-typesetting/tectonic/pull/1155
      name = "1155-fix-endless-reruns-when-generating-bbl";
      url = "https://github.com/tectonic-typesetting/tectonic/commit/fbb145cd079497b8c88197276f92cb89685b4d54.patch";
      hash = "sha256-6FW5MFkOWnqzYX8Eg5DfmLaEhVWKYVZwodE4SGXHKV0=";
    })
    ./tectonic-0.15-fix-dangerous_implicit_autorefs.patch
  ];

  cargoPatches = [
    (fetchpatch2 {
      # cherry-picked from https://github.com/tectonic-typesetting/tectonic/pull/1202
      name = "1202-fix-build-with-rust-1_80-and-icu-75";
      url = "https://github.com/tectonic-typesetting/tectonic/compare/19654bf152d602995da970f6164713953cffc2e6...6b49ca8db40aaca29cb375ce75add3e575558375.patch?full_index=1";
      hash = "sha256-CgQBCFvfYKKXELnR9fMDqmdq97n514CzGJ7EBGpghJc=";
    })
  ];

  cargoHash = "sha256-OMa89riyopKMQf9E9Fr7Qs4hFfEfjnDFzaSWFtkYUXE=";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [
    icu
    fontconfig
    harfbuzzFull
    openssl
  ];

  postInstall = ''
    # Makes it possible to automatically use the V2 CLI API
    ln -s $out/bin/tectonic $out/bin/nextonic
  ''
  + lib.optionalString clangStdenv.hostPlatform.isLinux ''
    substituteInPlace dist/appimage/tectonic.desktop \
      --replace Exec=tectonic Exec=$out/bin/tectonic
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  doCheck = true;

  meta = {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    mainProgram = "tectonic";
    maintainers = with lib.maintainers; [
      lluchs
      doronbehar
      bryango
    ];
  };
}
