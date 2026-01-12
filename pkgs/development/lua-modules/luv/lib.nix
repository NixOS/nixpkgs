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
    "-DBUILD_SHARED_LIBS=ON"
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

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];
}
