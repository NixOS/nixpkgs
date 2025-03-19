{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttdl";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "VladimirMarkelov";
    repo = "ttdl";
    rev = "v${version}";
    sha256 = "sha256-cCz2wxYvYAoI+Hmyll+Fn56NUCuWlIiJycmYvGyhkR4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-207Tmfs3LrZkwsAF/9qD5PN/zHwzCf0lq+87bFIP7y8=";

  meta = with lib; {
    description = "CLI tool to manage todo lists in todo.txt format";
    homepage = "https://github.com/VladimirMarkelov/ttdl";
    changelog = "https://github.com/VladimirMarkelov/ttdl/blob/v${version}/changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "ttdl";
  };
}
