{ lib
, lua
, luaOlder
, fetchurl
, fetchgit
, buildLuarocksPackage
, tomlplusplus
, magic-enum
, sol2
}:
buildLuarocksPackage {  pname = "toml";
  version = "0.3.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/toml-0.3.0-0.rockspec";
    sha256 = "0y4qdzsvf4xwnr49xcpbqclrq9d6snv83cbdkrchl0cn4cx6zpxy";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/LebJe/toml.lua.git",
  "rev": "319e9accf8c5cedf68795354ba81e54c817d1277",
  "date": "2023-02-19T23:00:49-05:00",
  "path": "/nix/store/p6a98sqp9a4jwsw6ghqcwpn9lxmhvkdg-toml.lua",
  "sha256": "05p33bq0ajl41vbsw9bx73shpf0p11n5gb6yy8asvp93zh2m51hq",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  patches = [ ./toml.patch ];

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [
    lua
    magic-enum
    sol2
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \
      "TOML_PLUS_PLUS_SRC" \
      "${tomlplusplus.src}"
  '';

  meta = {
    homepage = "https://github.com/LebJe/toml.lua";
    description = "TOML v1.0.0 parser and serializer for Lua. Powered by toml++.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}

