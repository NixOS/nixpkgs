{stdenv, fetchurl, boost-build, lua, boost}:

stdenv.mkDerivation rec {
  name = "luabind-0.9.1";

  src = fetchurl {
    url = "https://github.com/luabind/luabind/archive/v0.9.1.tar.gz";
    sha256 = "0e5ead50a07668d29888f2fa6f53220f900c886e46a2c99c7e8656842f05ff2d";
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
    homepage = https://github.com/luabind/luabind;
    description = "A library that helps you create bindings between C++ and Lua";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
