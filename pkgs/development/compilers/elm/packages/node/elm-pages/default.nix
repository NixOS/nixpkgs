{
  nodePkgs,
  pkgs,
  lib,
  makeWrapper,
}:

nodePkgs."elm-pages".overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    makeWrapper
    old.nodejs.pkgs.node-gyp-build
  ];

  # can't use `patches = [ <patch_file> ]` with a nodePkgs derivation;
  # need to patch in one of the build phases instead.
  # see upstream issue https://github.com/dillonkearns/elm-pages/issues/305 for dealing with the read-only problem
  preFixup = ''
    patch $out/lib/node_modules/elm-pages/generator/src/codegen.js ${./fix-read-only.patch}
    patch $out/lib/node_modules/elm-pages/generator/src/init.js ${./fix-init-read-only.patch}
  '';

  postFixup = ''
    wrapProgram $out/bin/elm-pages --prefix PATH : ${
      with pkgs.elmPackages;
      lib.makeBinPath [
        elm
        elm-review
        elm-optimize-level-2
      ]
    }
  '';

  meta =
    with lib;
    nodePkgs."elm-pages".meta
    // {
      description = "Statically typed site generator for Elm";
      homepage = "https://github.com/dillonkearns/elm-pages";
      license = licenses.bsd3;
      maintainers = [
        maintainers.turbomack
        maintainers.jali-clarke
      ];
    };
})
