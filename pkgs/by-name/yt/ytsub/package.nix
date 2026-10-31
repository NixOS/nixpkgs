{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ytsub";
  version = "0.11.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LhXdR60grbvqnUsQJYWqFy6c+fC7j95/n+oFn5CYOhM=";
  };

  cargoHash = "sha256-5siJSf4NzgyPbGcqziNR6ms5eneeZSt+tvQ/EICMZ8s=";

  buildInputs = [ sqlite ];

  meta = {
    description = "Subscriptions only TUI Youtube client";
    homepage = "https://github.com/sarowish/ytsub";
    changelog = "https://github.com/sarowish/ytsub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sarowish ];
    mainProgram = "ytsub";
  };
})
