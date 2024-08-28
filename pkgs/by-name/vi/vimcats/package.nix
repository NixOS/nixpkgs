{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  vimcats,
}:

rustPlatform.buildRustPackage rec {
  pname = "vimcats";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mrcjkb";
    repo = "vimcats";
    rev = "v${version}";
    sha256 = "sha256-YZPLZgC0v5zw/+X3r0G1MZ+46c0K8J3ClFQYH5BqbUE=";
  };

  buildFeatures = [ "cli" ];

  cargoHash = "sha256-gxCsB8lx9gTEsWV3uCX2TKTzxCUZ9JHo+1+voU7gKhY=";

  passthru.tests.version = testers.testVersion { package = vimcats; };

  meta = with lib; {
    description = "A CLI to generate vim/nvim help doc from LuaCATS. Forked from lemmy-help";
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
