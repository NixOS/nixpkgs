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
    rev = "v${version}";
    hash = "sha256-twV5vmQ5loR8j9guf0w5DG4sU4BQYz22GjqjsUkqE4U=";
  };

  # needed to fix https://github.com/NixOS/nixpkgs/issues/367282
  # once yo gets a new lockfile upstream, we can go back to regular
  # `npmDepsHash` and remove the `postPatch`.
  npmDeps = fetchNpmDeps {
    src = ./.;
    hash = "sha256-Fjt9/341lXW7YvyZVyAUMMcDITwyQxyG5WBgR9lJUy4=";
  };

  postPatch = "cp -v ${./package-lock.json} ./package-lock.json";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for running Yeoman generators";
    homepage = "https://github.com/yeoman/yo";
    license = lib.licenses.bsd2;
    mainProgram = "yo";
    maintainers = [ ];
  };
}
