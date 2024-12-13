{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  stdenv,
  darwin,
  mpv,
  youtube-dl,
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

  cargoHash = "sha256-766Wev2/R/9LLlWWxOPl6y4CBRUU4hUrTDlVVuoJ8C8=";

  checkFlags = [
    "--skip=tests::display_config_path"
    "--skip=tests::inspect_server_list"
  ];

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs =
    [
      openssl
      sqlite
      mpv
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  postInstall = ''
    wrapProgram $out/bin/ytui_music \
      --prefix PATH : ${lib.makeBinPath [ youtube-dl ]}
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
