{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  ctypes,
  integers,
  patch,
  gitUpdater,
}:

buildDunePackage rec {
  pname = "raylib";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tjammer";
    repo = "raylib-ocaml";
    tag = version;
    hash = "sha256-Fh79YnmboQF5Kn3VF//JKLaIFKl8QJWVOqRexTzxF0U=";
    # enable submodules for vendored raylib sources
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    dune-configurator
    ctypes
    integers
    patch
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "OCaml bindings for Raylib (5.0.0)";
    homepage = "https://tjammer.github.io/raylib-ocaml";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mit;
  };
}
