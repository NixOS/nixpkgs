{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "wl-crosshair";
  version = "0.1.0-unstable-2024-05-09";

  src = fetchFromGitHub {
    owner = "lelgenio";
    repo = "wl-crosshair";
    rev = "39b716cf410a1b45006f50f32f8d63de5c43aedb";
    hash = "sha256-q5key9BWJjJQqECrhflso9ZTzULBeScvromo0S4fjqE=";
  };

  cargoHash = "sha256-34K8Vjb7MrB8WGGLase+GnN2bUDuAnvU6VWRV1k+ZYM=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir -p $out/share
    cp -r ./cursors $out/share/cursors
    wrapProgram $out/bin/wl-crosshair \
      --set-default WL_CROSSHAIR_IMAGE_PATH $out/share/cursors/inverse-v.png
  '';

  meta = {
    description = "Crosshair overlay for wlroots compositor";
    homepage = "https://github.com/lelgenio/wl-crosshair";
    license = lib.licenses.unfree; # didn't found a license
    mainProgram = "wl-crosshair";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.linux;
  };
}
