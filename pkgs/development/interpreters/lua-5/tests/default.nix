{ lua
, hello
, wrapLua
, lib, fetchFromGitHub
, fetchFromGitLab
, pkgs
}:
let

  runTest = lua: { name, command }:
    pkgs.runCommandLocal "test-${lua.name}" ({
      nativeBuildInputs = [lua];
      meta.platforms = lua.meta.platforms;
    }) (''
      source ${./assert.sh}
    ''
    + command
    + "touch $out"
    );

    wrappedHello = hello.overrideAttrs(oa: {
      propagatedBuildInputs = [
        wrapLua
        lua.pkgs.cjson
      ];
      postFixup = ''
        wrapLuaPrograms
      '';
    });
in
  pkgs.recurseIntoAttrs ({

  checkAliases = runTest lua {
    name = "check-aliases";
    command = ''
      generated=$(lua -e 'print(package.path)')
      golden_LUA_PATH='./share/lua/${lua.luaversion}/?.lua;./?.lua;./?/init.lua'

      assertStringEqual "$generated" "$golden_LUA_PATH"
      '';
  };

  checkWrapping = pkgs.runCommandLocal "test-${lua.name}" ({
    }) (''
      grep -- 'LUA_PATH=' ${wrappedHello}/bin/hello
      touch $out
    '');

})

