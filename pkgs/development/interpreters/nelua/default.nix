{ lib, stdenv, fetchFromGitHub, luaPackages, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "nelua";
  version = "0-unstable-2024-06-11";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "c344dbdcdc4a6fed964e60fbde39d1cebe23c05a";
    hash = "sha256-goNiw/JlLJfgwVI+0dfdnBymAAKCU7u0Mjo1CyCFsSc=";
  };

  postPatch = ''
    substituteInPlace lualib/nelua/version.lua \
      --replace "NELUA_GIT_HASH = nil" "NELUA_GIT_HASH = '${src.rev}'" \
      --replace "NELUA_GIT_DATE = nil" "NELUA_GIT_DATE = '${lib.removePrefix "0-unstable-" version}'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  nativeCheckInputs = [ luaPackages.luacheck ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater {
    # no releases, only stale "latest" tag
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Minimal, efficient, statically-typed and meta-programmable systems programming language heavily inspired by Lua, which compiles to C and native code";
    homepage = "https://nelua.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
