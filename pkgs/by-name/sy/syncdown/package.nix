{ lib, stdenv, bun, cacert, fetchFromGitHub, writeShellScriptBin
, autoPatchelfHook, }:
let
  pname = "syncdown";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hjinco";
    repo = "syncdown";
    rev = "cf7ef40af6c8a5f7b46a1798d3b367d6ddb1a108";
    hash = "sha256-J9OccGQeWPxs/OC4iDvr9yyZC2WrTofW9SZ5XDb4MIU=";
  };

  srcWithDeps = stdenv.mkDerivation {
    name = "syncdown-src-with-deps";
    inherit src;
    nativeBuildInputs = [ bun cacert ];
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-JuDE6Df6cue3hQz9aAXr7nq377eNIzb9z2S9RldrR0I=";
    buildPhase = ''
      export HOME=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts
    '';
    installPhase = "cp -r . $out";
  };
in writeShellScriptBin "syncdown" ''
  exec ${bun}/bin/bun run ${srcWithDeps}/apps/cli/src/bin.ts "$@"
''
