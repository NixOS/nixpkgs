{
  lib,
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fontconfig,
  libffi,
  libpulseaudio,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  wayland,
  enableAlsaWidget ? true,
  enablePulseaudioWidget ? true,
}:

let
  pname = "wldash";
  version = "0.3.0";
  libraryPath = lib.makeLibraryPath [
    wayland
    libxkbcommon
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  buildNoDefaultFeatures = true;
  buildFeatures =
    [
      "yaml-cfg"
      "json-cfg"
    ]
    ++ lib.optionals enableAlsaWidget [ "alsa-widget" ]
    ++ lib.optionals enablePulseaudioWidget [ "pulseaudio-widget" ];

  src = fetchFromGitHub {
    owner = "kennylevinsen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZzsBD3KKTT+JGiFCpdumPyVAE2gEJvzCq+nRnK3RdxI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      dbus
      fontconfig
    ]
    ++ lib.optionals enableAlsaWidget [ alsa-lib ]
    ++ lib.optionals enablePulseaudioWidget [ libpulseaudio ];

  cargoPatches = [
    ./0001-Update-Cargo.lock.patch
    ./0002-Update-fontconfig.patch
  ];

  cargoSha256 = "sha256-Y7nhj8VpO6sEzVkM3uPv8Tlk2jPn3c/uPJqFc/HjHI0=";

  dontPatchELF = true;

  postInstall = ''
    patchelf --set-rpath ${libraryPath}:$(patchelf --print-rpath $out/bin/wldash) $out/bin/wldash
  '';

  meta = {
    description = "Wayland launcher/dashboard";
    homepage = "https://github.com/kennylevinsen/wldash";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bbenno ];
    mainProgram = "wldash";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
