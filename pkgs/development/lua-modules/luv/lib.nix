{
  lib,
  cmake,
  fixDarwinDylibNames,
  isLuaJIT,
  libuv,
  lua,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "libluv";
  inherit (lua.pkgs.luv) version src meta;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    "-DBUILD_MODULE=OFF"
    "-DWITH_SHARED_LIBUV=ON"
    "-DLUA_BUILD_TYPE=System"
    "-DWITH_LUA_ENGINE=${if isLuaJIT then "LuaJit" else "Lua"}"
  ];

  # to make sure we dont use bundled deps
  prePatch = ''
    rm -rf deps/lua deps/luajit deps/libuv
  '';

  buildInputs = [
    libuv
    lua
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  passthru.tests = {
    # Test luv too
    luv = lua.pkgs.luv.passthru.tests.test;
  };
}
