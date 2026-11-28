{
  callPackage,
  lib,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cryptography,
  typing-extensions,
  zlib-ng,
  uvloop,
  orjson,
  coincurve,
  aiohappyeyeballs,
  aiosignal,
  attrs,
  frozenlist,
  propcache,
  cffi,
  pycparser,
}:

let
  pinnedDeps = callPackage ./deps.nix { }; # https://github.com/NixOS/nixpkgs/blob/c7e10647eadb53b7cf3552a53e8bb33c8248c8c3/pkgs/by-name/README.md?plain=1#L187-L205
in
buildPythonPackage (finalAttrs: {
  pname = "ccxt";
  version = "4.5.92";
  src = fetchFromGitHub {
    owner = "ccxt";
    repo = "ccxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3sL6eIYrhMt7hk0IRRRPforDF7WwyKK6O+EZBp2OjqE=";
  };
  pyproject = true;
  build-system = [ setuptools ];
  passthru = { inherit pinnedDeps; };
  dependencies = [
    setuptools
    pinnedDeps.certifi
    pinnedDeps.requests
    cryptography
    typing-extensions
    pinnedDeps.aiohttp
    pinnedDeps.yarl
    pinnedDeps.aiohttp-fast-zlib
    zlib-ng
    uvloop
  ]
  # https://github.com/ccxt/ccxt/blob/e6fd82900c9f2b71fa0fa7524d95dd788e2803fc/pyproject.toml#L68
  ++ lib.optional (pythonOlder "3.15") orjson
  ++ lib.optional (pythonOlder "3.14") coincurve
  ++ [
    aiohappyeyeballs
    aiosignal
    attrs
    frozenlist
    pinnedDeps.multidict
    propcache
    cffi
    pycparser
    pinnedDeps.charset-normalizer
    pinnedDeps.idna
    pinnedDeps.urllib3
  ];
  postPatch = ''
    # https://github.com/ccxt/ccxt/blob/e6fd82900c9f2b71fa0fa7524d95dd788e2803fc/pyproject.toml#L88-L90
    # too many transitive usages to override
    substituteInPlace pyproject.toml \
      --replace-fail '"cffi==2.0.0"' '"cffi"' \
      --replace-fail '"pycparser==3.0"' '"pycparser"'
  '';
  meta = {
    description = "A unified trading API with more than 100 crypto exchanges and prediction markets in JavaScript / TypeScript / Python / C# / PHP / Go / Java / Rust";
    homepage = "https://ccxt.com";
    changelog = "https://github.com/ccxt/ccxt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
