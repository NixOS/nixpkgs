{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  vimcats,
}:

rustPlatform.buildRustPackage rec {
  pname = "vimcats";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mrcjkb";
    repo = "vimcats";
    rev = "v${version}";
    hash = "sha256-QV/eIy6yd6Lnmo8XV+E37/oCZCC3jlPu31emH0MgiO4=";
  };

  buildFeatures = [ "cli" ];

  cargoHash = "sha256-LBiuh7OkEoOkoPXCeGnDQLSlRIMkbiWyCv0dk0y7swk=";

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
