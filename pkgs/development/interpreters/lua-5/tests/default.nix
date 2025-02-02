{ lua
, hello
, wrapLua
, lib
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

  golden_LUA_PATHS = {

    # Looking at lua interpreter 'setpath' code
    # for instance https://github.com/lua/lua/blob/69ea087dff1daba25a2000dfb8f1883c17545b7a/loadlib.c#L599
    # replace ";;" by ";LUA_PATH_DEFAULT;"
    "5.1" = ";./?.lua;${lua}/share/lua/5.1/?.lua;${lua}/share/lua/5.1/?/init.lua;${lua}/lib/lua/5.1/?.lua;${lua}/lib/lua/5.1/?/init.lua;";
    "5.2" = ";${lua}/share/lua/5.2/?.lua;${lua}/share/lua/5.2/?/init.lua;${lua}/lib/lua/5.2/?.lua;${lua}/lib/lua/5.2/?/init.lua;./?.lua;";
    "5.3" = ";${lua}/share/lua/5.3/?.lua;${lua}/share/lua/5.3/?/init.lua;${lua}/lib/lua/5.3/?.lua;${lua}/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;";
    # lua5.4 seems to be smarter about it and dont add the lua separators when nothing left or right
    "5.4" = "${lua}/share/lua/5.4/?.lua;${lua}/share/lua/5.4/?/init.lua;${lua}/lib/lua/5.4/?.lua;${lua}/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua";

    # luajit versions
    "2.0" = ";./?.lua;${lua}/share/luajit-2.0/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;${lua}/share/lua/5.1/?.lua;${lua}/share/lua/5.1/?/init.lua;";
    "2.1" = ";./?.lua;${lua}/share/luajit-2.1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;${lua}/share/lua/5.1/?.lua;${lua}/share/lua/5.1/?/init.lua;";
  };
in
  pkgs.recurseIntoAttrs ({

  checkInterpreterPatch = let
    golden_LUA_PATH = golden_LUA_PATHS.${lib.versions.majorMinor lua.version};
  in
    runTest lua {
    name = "check-default-lua-path";
    command = ''
      export LUA_PATH=";;"
      generated=$(lua -e 'print(package.path)')
      assertStringEqual "$generated" "${golden_LUA_PATH}"
      '';
  };

  checkWrapping = pkgs.runCommandLocal "test-${lua.name}-wrapping" ({
    }) (''
      grep -- 'LUA_PATH=' ${wrappedHello}/bin/hello
      touch $out
    '');

  # checks that lua's setup-hook adds dependencies to LUA_PATH
  # Prevents the following regressions
  # $ env NIX_PATH=nixpkgs=. nix-shell --pure -Q -p luajitPackages.lua luajitPackages.http
  # nix-shell$ luajit
  # > require('http.request')
  # stdin:1: module 'http.request' not found:
  checkSetupHook = pkgs.runCommandLocal "test-${lua.name}-setup-hook" ({
      nativeBuildInputs = [lua];
      buildInputs = [ lua.pkgs.http ];
      meta.platforms = lua.meta.platforms;
    }) (''
      ${lua}/bin/lua -e "require'http.request'"
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
