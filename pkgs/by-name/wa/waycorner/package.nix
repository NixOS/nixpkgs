{
  lib,
  makeWrapper,
  rustPlatform,
  pkg-config,
  fetchFromGitHub,
  wayland,
  gitUpdater,
}:
rustPlatform.buildRustPackage rec {
  pname = "waycorner";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "AndreasBackx";
    repo = "waycorner";
    tag = version;
    hash = "sha256-b8juIhJ3kh+NJc8RUVVoatqjWISSW0ir/vk2Dz/428Y=";
  };

  cargoHash = "sha256-sMsqH4+Vhqiu5GKPs9FQMQjjc2H6ZGZosd4Qj3DlBqA=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postFixup = ''
    # the program looks for libwayland-client.so at runtime
    wrapProgram $out/bin/waycorner \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Hot corners for Wayland";
    mainProgram = "waycorner";
    changelog = "https://github.com/AndreasBackx/waycorner/blob/${version}/CHANGELOG.md";
    homepage = "https://github.com/AndreasBackx/waycorner";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
  };
}
