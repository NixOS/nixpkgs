{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  vimcats,
}:

rustPlatform.buildRustPackage rec {
  pname = "vimcats";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "mrcjkb";
    repo = "vimcats";
    rev = "v${version}";
    hash = "sha256-BW1pU7NnW8yWePV0IQOUmcNa13NvV9lOZhfnEdQFBQQ=";
  };

  buildFeatures = [ "cli" ];

  cargoHash = "sha256-OGU7jwXOUf+tVECsyKwJQ9vRqTDoV8m/WOlAqTFdfUM=";

  passthru.tests.version = testers.testVersion { package = vimcats; };

  meta = with lib; {
    description = "CLI to generate vim/nvim help doc from LuaCATS. Forked from lemmy-help";
    longDescription = ''
      `vimcats` is a LuaCATS parser as well as a CLI which takes that parsed tree and converts it into vim help docs.
      It is a fork of lemmy-help that aims to support more recent LuaCATS features.
    '';
    homepage = "https://github.com/mrcjkb/vimcats";
    changelog = "https://github.com/mrcjkb/vimcats/CHANGELOG.md";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ mrcjkb ];
    mainProgram = "vimcats";
  };
}
