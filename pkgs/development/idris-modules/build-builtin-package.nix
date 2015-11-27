{ idris, build-idris-package }: name: deps: build-idris-package (args: {
  inherit name;

  propagatedBuildInputs = deps;

  inherit (idris) src;

  postUnpack = ''
    mv $sourceRoot/libs/${name} $IDRIS_LIBRARY_PATH
    sourceRoot=$IDRIS_LIBRARY_PATH/${name}
  '';
})
