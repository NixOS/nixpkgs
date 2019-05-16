# Build one of the packages that comes with idris
# name: The name of the package
# deps: The dependencies of the package
{ idris, build-idris-package }: name: deps:
let
  inherit (builtins.parseDrvName idris.name) version;
in
build-idris-package {

  inherit name version;
  inherit (idris) src;

  noPrelude = true;
  noBase = true;

  idrisDeps = deps;

  postUnpack = ''
    sourceRoot=$sourceRoot/libs/${name}
  '';

  meta = idris.meta // {
    description = "${name} builtin Idris library";
  };
}
