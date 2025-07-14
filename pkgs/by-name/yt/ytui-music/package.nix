{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  mpv,
  yt-dlp,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "ytui-music";
  version = "2.0.0-rc1";

  src = fetchFromGitHub {
    owner = "sudipghimire533";
    repo = "ytui-music";
    rev = "v${version}";
    hash = "sha256-f/23PVk4bpUCvcQ25iNI/UVXqiPBzPKWq6OohVF41p8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-I+ciLSMvV9EqlfA1+/IC1w7pWpj9HHF/DTfAbKw2CVM=";

  checkFlags = [
    "--skip=tests::display_config_path"
    "--skip=tests::inspect_server_list"
  ];

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
    sqlite
    mpv
  ];

  postInstall = ''
    wrapProgram $out/bin/ytui_music \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/ytui_music help

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Youtube client in terminal for music";
    homepage = "https://github.com/sudipghimire533/ytui-music";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "ytui_music";
  };
}
