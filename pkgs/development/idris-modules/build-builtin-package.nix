# Build one of the packages that come with idris
# name: The name of the package
# deps: The dependencies of the package
{ idris, build-idris-package, lib }: name: deps:
let
  inherit (builtins.parseDrvName idris.name) version;
in
build-idris-package {
  name = "${name}-${version}";

  propagatedBuildInputs = deps;

  inherit (idris) src;

  postUnpack = ''
    sourceRoot=$sourceRoot/libs/${name}
  '';

  postPatch = ''
    sed -i ${name}.ipkg -e "/^opts/ s|-i \\.\\./|-i $IDRIS_LIBRARY_PATH/|g"
  '';

  meta = idris.meta // {
    description = "${name} builtin Idris library";
  };
}
