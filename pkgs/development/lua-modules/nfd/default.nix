{ fetchFromGitHub, buildLuarocksPackage, lua, maintainers, pkg-config
, substituteAll, zenity }:

buildLuarocksPackage {
  pname = "nfd";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "Vexatos";
    repo = "nativefiledialog";
    rev = "2f74a5758e8df9b27158d444953697bc13fe90d8";
    sha256 = "1f52mb0s9zrpsqjp10bx92wzqmy1lq7fg1fk1nd6xmv57kc3b1qv";
    fetchSubmodules = true;
  };

  # use zenity because default gtk impl just crashes
  patches = [
    (substituteAll {
      src = ./zenity.patch;
      inherit zenity;
    })
  ];
  rockspecDir = "lua";

  extraVariables.LUA_LIBDIR = "${lua}/lib";
  nativeBuildInputs = [ pkg-config ];

  fixupPhase = ''
    find $out -name nfd_zenity.so -execdir mv {} nfd.so \;
  '';

  disabled = with lua; (luaversion != "5.1");

  meta = {
    description =
      "A tiny, neat lua library that portably invokes native file open and save dialogs.";
    homepage = "https://github.com/Alloyed/nativefiledialog/tree/master/lua";
    license.fullName = "zlib";
    maintainers = [ maintainers.scoder12 ];
  };
}
