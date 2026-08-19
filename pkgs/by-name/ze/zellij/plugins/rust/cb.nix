{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-cb";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "zellij-cb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wXUwtjMsSbReU6YFZkk3CUYKetvicEQChBOa8cDBzN4=";
  };

  cargoHash = "sha256-IUYl5lclnlfO9ftFF0KDqAle9afHzhBcl6GWOIUHRWA=";

  meta = {
    description = "Customizable compact bar plugin for Zellij";
    homepage = "https://github.com/ndavd/zellij-cb";
    changelog = "https://github.com/ndavd/zellij-cb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ndavd ];
  };
})
