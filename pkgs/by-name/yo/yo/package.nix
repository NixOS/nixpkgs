{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "yo";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "yeoman";
    repo = "yo";
    tag = "v${version}";
    hash = "sha256-twV5vmQ5loR8j9guf0w5DG4sU4BQYz22GjqjsUkqE4U=";
  };

  # needed to fix https://github.com/NixOS/nixpkgs/issues/367282
  # once yo gets a new lockfile upstream, we can go back to regular
  # `npmDepsHash` and remove the `postPatch`.
  npmDeps = fetchNpmDeps {
    src = fetchFromGitHub {
      owner = "yeoman";
      repo = "yo";
      rev = "96ebb14020a7f3f10699b3f88eadfa063a9e6b07";
      hash = "sha256-wMxH9Er+gb6rsSEgmH0zA4d6yvP2PSpsV+A0nBTIxBI=";
    };
    hash = "sha256-7TAH4Im+H7fbjI0xUxYZficcFQNZbweK2U0hGCZV+lQ=";
  };

  postPatch = "cp -v ${npmDeps.src}/package-lock.json ./package-lock.json";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for running Yeoman generators";
    homepage = "https://github.com/yeoman/yo";
    license = lib.licenses.bsd2;
    mainProgram = "yo";
    maintainers = [ ];
  };
}
