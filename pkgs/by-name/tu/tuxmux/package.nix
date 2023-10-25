{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tuxmux";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "edeneast";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QySDC/aEU9Fo0UbRUNvgBQLfESYzENGfS8Tl/ycn1YY=";
  };

  cargoHash = "sha256-MlLTaN+KMeF0A1hh0oujLYWqjwrbmoNzoRoXjeCUf7I=";

  buildInputs = [ openssl ] ++ (lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ]);
  nativeBuildInputs = [ pkg-config installShellFiles ];

  postInstall = ''
    installShellCompletion $releaseDir/../completions/tm.{bash,fish}
    installShellCompletion --zsh $releaseDir/../completions/_tm

    installManPage $releaseDir/../man/*
  '';

  meta = with lib; {
    description = "Tmux session manager";
    homepage = "https://github.com/edeneast/tuxmux";
    license = licenses.apsl20;
    maintainers = with maintainers; [ edeneast ];
    mainProgram = "tm";
  };
}
