{ lib, stdenv, fetchFromGitHub, luaPackages, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "nelua";
  version = "0-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "38c2d9ca14c992ddcd73f4067af8c6f37c550979";
    hash = "sha256-mpKGD9YP+D+1ySq+8lyRjXwptWL+uBG/p37bHDBoTJ8=";
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
