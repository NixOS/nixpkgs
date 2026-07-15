{
  fetchFromGitHub,
  buildLuarocksPackage,
  lua,
  pkg-config,
  lib,
  replaceVars,
  zenity,
}:

buildLuarocksPackage {
  pname = "nfd";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "Vexatos";
    repo = "nativefiledialog";
    rev = "bea4560b9269bdc142fef946ccd8682450748958";
    hash = "sha256-veCLHTmZU4puZW0NHeWFZa80XKc6w6gxVLjyBmTrejg=";
    fetchSubmodules = true;
  };

  # use zenity because default gtk impl just crashes
  patches = [
    (replaceVars ./zenity.patch {
      inherit zenity;
    })
  ];
  knownRockspec = "lua/nfd-scm-1.rockspec";

  luarocksConfig.variables.LUA_LIBDIR = "${lua}/lib";
  nativeBuildInputs = [ pkg-config ];

  postInstall = ''
    find $out -name nfd_zenity.so -execdir mv {} nfd.so \;
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ lua.pkgs.busted ];
  installCheckPhase = ''
    busted lua/spec/
  '';

  meta = {
    description = "Tiny, neat Lua library that invokes native file open and save dialogs";
    homepage = "https://github.com/Alloyed/nativefiledialog/tree/master/lua";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.scoder12 ];
    broken = lua.luaversion != "5.1";
  };
}
