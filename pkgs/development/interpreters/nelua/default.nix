{ lib, stdenv, fetchFromGitHub, luaPackages, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "nelua";
  version = "unstable-2023-11-19";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "e82695abf0a68a30a593cefb0bf1143cf9e14b6b";
    hash = "sha256-Srgoq07JQirxmZcDvw4UdfoYZ5HFT0PbYPoHY99BW/c=";
  };

  postPatch = ''
    substituteInPlace lualib/nelua/version.lua \
      --replace "NELUA_GIT_HASH = nil" "NELUA_GIT_HASH = '${src.rev}'" \
      --replace "NELUA_GIT_DATE = nil" "NELUA_GIT_DATE = '${lib.removePrefix "unstable-" version}'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  nativeCheckInputs = [ luaPackages.luacheck ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Minimal, efficient, statically-typed and meta-programmable systems programming language heavily inspired by Lua, which compiles to C and native code";
    homepage = "https://nelua.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
