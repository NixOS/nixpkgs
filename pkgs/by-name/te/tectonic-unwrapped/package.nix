/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `../tectonic/package.nix`, by wrapping
  - [`tectonic-unwrapped`](./package.nix) i.e. this package, and
  - [`biber-for-tectonic`](../../bi/biber-for-tectonic/package.nix),
    which provides a compatible version of `biber`.
*/

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fontconfig,
  harfbuzzFull,
  openssl,
  pkg-config,
  icu,
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  # https://github.com/tectonic-typesetting/tectonic/issues/1263
  version = "0.15.0-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "c2ae25ff1facd9e9cce31b48944b867773f709ec";
    sha256 = "sha256-cDCJ1Tu2lA4KvN2EBUtT0MvMtkejd8YAoNRkNeoreEc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dBthzRS+9wqKCwmo5cY/ynTdfIPK3QCsbZ2vAQ8q7aM=";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [
    icu
    fontconfig
    harfbuzzFull
    openssl
  ];

  postInstall =
    ''
      # Makes it possible to automatically use the V2 CLI API
      ln -s $out/bin/tectonic $out/bin/nextonic
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace dist/appimage/tectonic.desktop \
        --replace Exec=tectonic Exec=$out/bin/tectonic
      install -D dist/appimage/tectonic.desktop -t $out/share/applications/
      install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
    '';

  doCheck = true;
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  checkFlags = [
    # https://github.com/tectonic-typesetting/tectonic/issues/1263
    "--skip=tests::no_segfault_after_failed_compilation"
  ];

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
