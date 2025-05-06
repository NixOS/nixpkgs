{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tui-journal";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "AmmarAbouZor";
    repo = "tui-journal";
    rev = "v${version}";
    hash = "sha256-XbOKC+utKt53iFzNbm861tMGsNMZ2GQc+/J0Dm/SYS8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gleNWRs9oCI9TH5ALS/wvC88OooMfSTJvz+UVWFYrs4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  meta = with lib; {
    description = "Your journal app if you live in a terminal";
    homepage = "https://github.com/AmmarAbouZor/tui-journal";
    changelog = "https://github.com/AmmarAbouZor/tui-journal/blob/${src.rev}/CHANGELOG.ron";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tjournal";
  };
}
