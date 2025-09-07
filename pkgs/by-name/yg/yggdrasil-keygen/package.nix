{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "yggdrasil-keygen";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jcgruenhage";
    repo = "yggdrasil-keygen";
    rev = "v${version}";
    hash = "sha256-ejiE1/19vJcHvgW3zh7IV6AXDQvAvc4o1EVrUYrMrZY=";
  };

  cargoHash = "sha256-PKhKdSX/7Frrh5+6Wpr03fzBN2A2lDCvL63igoTlXYI=";

  meta = {
    description = "A small executable to generate yggdrasil keys";
    homepage = "https://github.com/jcgruenhage/yggdrasil-keygen";
    changelog = "https://github.com/jcgruenhage/yggdrasil-keygen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      flokli
    ];
    mainProgram = "yggdrasil-keygen";
  };
}
