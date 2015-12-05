# Build one of the packages that come with idris
# name: The name of the package
# deps: The dependencies of the package
{ idris, build-idris-package, lib }: name: deps: build-idris-package {
  inherit name;

  propagatedBuildInputs = deps;

  inherit (idris) src;

  postUnpack = ''
    mv $sourceRoot/libs/${name} $IDRIS_LIBRARY_PATH
    sourceRoot=$IDRIS_LIBRARY_PATH/${name}
  '';

  meta = idris.meta // {
    description = "${name} builtin Idris library";
  };
}
