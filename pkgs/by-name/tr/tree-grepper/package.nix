{
  lib,
  tree-sitter,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "tree-grepper";
  # no releases since 2022 but active development:
  # https://github.com/BrianHicks/tree-grepper/issues/688
  version = "2.5.0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "BrianHicks";
    repo = "tree-grepper";
    rev = "c05ae50bd96e131569f1020c60219720dd8fe29c";
    hash = "sha256-UTkOzyM78Fawf0PtzBTrTH4yveb4Fy4HMSdm6dVuJjI=";
  };

  # HACK: There's not dynamic loading support so we have to just build the
  # grammars in. Someone should fix this upstream.
  # https://github.com/BrianHicks/tree-grepper/issues/88
  preBuild = ''
    ln -sf ${tree-sitter.grammars} vendor
  '';

  cargoHash = "sha256-Y1fzMQUsQZsfAk+Lmdmgax7xvg94DC+Rf8YK1yCSaaw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "tree-sitter based AST search tool";
    maintainers = with lib.maintainers; [ lf- ];
    license = lib.licenses.hl2_1;
    platforms = lib.platforms.unix;
  };
}
