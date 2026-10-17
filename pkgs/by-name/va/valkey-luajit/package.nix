{
  cmake,
  fetchFromGitHub,
  lib,
  luajit,
  replaceVars,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valkey-luajit";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-luajit";
    tag = finalAttrs.version;
    hash = "sha256-8sI9hw3ALEtWNH2tBi1la+21MAv2opRsEcjNeZkTu1g=";
  };

  patches = [
    (replaceVars ./external-libs.patch {
      luajit_include = "${luajit}/include";
      luajit_lib = "${luajit}/lib/libluajit-5.1.a";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ luajit ];

  meta = {
    changelog = "https://github.com/valkey-io/valkey-luajit/releases/tag/${finalAttrs.src.tag}";
    description = "Module which replaces the built-in Lua with LuaJIT for Valkey";
    homepage = "https://github.com/valkey-io/valkey-luajit";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
