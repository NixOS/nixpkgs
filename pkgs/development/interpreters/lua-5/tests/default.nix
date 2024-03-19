{ lua
, hello
, wrapLua
, lib, fetchFromGitHub
, fetchFromGitLab
, pkgs
}:
let

  runTest = lua: { name, command }:
    pkgs.runCommandLocal "test-${lua.name}-${name}" ({
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

    luaWithModule = lua.withPackages(ps: [
      ps.lua-cjson
    ]);
in
  pkgs.recurseIntoAttrs ({

  checkAliases = runTest lua {
    name = "check-aliases";
    command = ''
      generated=$(lua -e 'print(package.path)')
      golden_LUA_PATH='./share/lua/${lua.luaversion}/?.lua;./?.lua;./?/init.lua'

      assertStringContains "$generated" "$golden_LUA_PATH"
      '';
  };

  checkWrapping = pkgs.runCommandLocal "test-${lua.name}-wrapping" ({
    }) (''
      grep -- 'LUA_PATH=' ${wrappedHello}/bin/hello
      touch $out
    '');

  checkRelativeImports = pkgs.runCommandLocal "test-${lua.name}-relative-imports" ({
    }) (''
      source ${./assert.sh}

      lua_vanilla_package_path="$(${lua}/bin/lua -e "print(package.path)")"
      lua_with_module_package_path="$(${luaWithModule}/bin/lua -e "print(package.path)")"

      assertStringContains "$lua_vanilla_package_path" "./?.lua"
      assertStringContains "$lua_vanilla_package_path" "./?/init.lua"

      assertStringContains "$lua_with_module_package_path" "./?.lua"
      assertStringContains "$lua_with_module_package_path" "./?/init.lua"

      touch $out
    '');
})
