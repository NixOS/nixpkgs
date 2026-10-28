{
  lib,
  buildLuaPackage,
  writeScript,
  fetchFromGitHub,
  cmake,
  lua,
  curl,
}:

buildLuaPackage rec {
  pname = "lua-https";
  version = "0-unstable-2025-02-28";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "lua-https";
    rev = "e1b77046dd3cf1a9f61ddeb63cb39d47c844c089";
    hash = "sha256-NQVB5ncw2bYJEHPQtBXqCdwp6FdQ4SJ/x97fasE5z0A=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lua
    curl
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib/lua/${lua.luaversion}")
    (lib.cmakeFeature "LIBRARY_LOADER" "linktime")
    (lib.cmakeBool "USE_CURL_BACKEND" true) # off by default on darwin
    (lib.cmakeBool "USE_OPENSSL_BACKEND" false) # on by default on linux, but incompatible with linktime library loader
    (lib.cmakeBool "USE_NSURL_BACKEND" false) # on by default on darwin
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -euo pipefail

    response=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/${src.owner}/${src.repo}/commits?per_page=1")
    rev=$(echo "$response" | jq -r '.[0].sha')
    date=$(echo "$response" | jq -r '.[0].commit.committer.date' | cut -c1-10)
    update-source-version luaPackages.lua-https 0-unstable-$date --rev=$rev
  '';

  meta = {
    homepage = "https://love2d.org/wiki/lua-https";
    description = "Simple Lua HTTPS module using native platform backends specifically written for LÖVE 12.0";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
