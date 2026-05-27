{
  buildLuarocksPackage,
  fetchFromGitHub,
  lib,
  lua,
  luaOlder,
  luajitPackages,
}:
buildLuarocksPackage rec {
  pname = "image.nvim";
  version = "1.5.1";

  disabled = luaOlder "5.1";
  knownRockspec = "image.nvim-scm-1.rockspec";
  rockspecVersion = "scm-1";

  src = fetchFromGitHub {
    owner = "3rd";
    repo = "image.nvim";
    tag = "v${version}";
    hash = "sha256-brDtVYD3O+7N2RdQPIx2+6P+faXafoJDUITy0z0cIuA=";
  };

  propagatedBuildInputs = [
    lua
    luajitPackages.magick
  ];

  meta = {
    homepage = "https://github.com/3rd/image.nvim";
    description = "🖼️ Bringing images to Neovim.";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license.fullName = "MIT";
  };
}
