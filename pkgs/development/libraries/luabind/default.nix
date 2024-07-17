{
  lib,
  stdenv,
  fetchFromGitHub,
  lua,
  boost,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "luabind";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Oberon00";
    repo = "luabind";
    rev = "49814f6b47ed99e273edc5198a6ebd7fa19e813a";
    sha256 = "sha256-JcOsoQHRvdzF2rsZBW6egOwIy7+7C4wy0LiYmbV590Q";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  propagatedBuildInputs = [ lua ];

  passthru = {
    inherit lua;
  };

  patches = [ ./0.9.1-discover-luajit.patch ];

  meta = {
    homepage = "https://github.com/Oberon00/luabind";
    description = "A library that helps you create bindings between C++ and Lua";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
