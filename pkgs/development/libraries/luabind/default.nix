{ lib, stdenv, fetchFromGitHub, boost-build, lua, boost }:

stdenv.mkDerivation rec {
  pname = "luabind";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "luabind";
    repo = "luabind";
    rev = "v${version}";
    sha256 = "sha256-sK1ca2Oj9yXdmxyXeDO3k8YZ1g+HxIXLhvdTWdPDdag=";
  };

  patches = [ ./0.9.1_modern_boost_fix.patch ./0.9.1_boost_1.57_fix.patch ./0.9.1_discover_luajit.patch ];

  buildInputs = [ boost-build lua boost ];

  propagatedBuildInputs = [ lua ];

  buildPhase = "LUA_PATH=${lua} bjam release";

  installPhase = "LUA_PATH=${lua} bjam --prefix=$out release install";

  passthru = {
    inherit lua;
  };

  meta = {
    homepage = "https://github.com/luabind/luabind";
    description = "A library that helps you create bindings between C++ and Lua";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
