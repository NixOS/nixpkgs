{ lib
, buildLuarocksPackage
, cargo
, fetchurl
, fetchgit
, lua
, luaOlder
, luarocks-build-rust-mlua
, rustPlatform }:
# NOTE: This is based on `luarocks-nix --nix toml-edit`,
# but requires some manual modifications, because this package uses cargo to build
buildLuarocksPackage rec {
  pname = "toml-edit";
  version = "0.1.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/toml-edit-0.1.4-1.rockspec";
    sha256 = "05bcc1xafcspdf1rcka9bhg7b6z617b4jrcahs1r7grcp78w89vf";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/vhyrro/toml-edit.lua",
  "rev": "f6efdab4ca6fab276f172060971781dc42a94f2d",
  "date": "2023-10-02T16:54:10+02:00",
  "path": "/nix/store/p1368agmqg4jwb1qvf2iff3fdrq9vkdj-toml-edit.lua",
  "sha256": "1aa8znjnmm84392gnl7w0hm069xfv7niym3i8my7kyk0vdgxja06",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");


  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-pLAisfnSDoAToQO/kdKTdic6vEug7/WFNtgOfj0bRAE=";
  };

  propagatedBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    lua
    luarocks-build-rust-mlua
  ];

  meta = {
    homepage = "https://github.com/vhyrro/toml-edit.lua";
    description = "TOML Parser + Formatting and Comment-Preserving Editor";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}

