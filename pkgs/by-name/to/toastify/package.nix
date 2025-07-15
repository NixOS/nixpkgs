{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "toastify";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "hoodie";
    repo = "toastify";
    rev = "v${version}";
    sha256 = "sha256-hSBh1LTfe3rQDPUryo2Swdf/yLYrOQ/Fg3Dz7ZqV3gw=";
  };

  cargoHash = "sha256-xnmns0YXsKuoNxxax3St5pLiFwu6BD0iIYHNi9N9mO0=";

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Commandline tool that shows desktop notifications using notify-rust";
    homepage = "https://github.com/hoodie/toastify";
    changelog = "https://github.com/hoodie/toastify/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "toastify";
  };
}
