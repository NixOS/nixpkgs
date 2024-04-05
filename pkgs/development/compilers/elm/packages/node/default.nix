{ pkgs, lib, nodejs, makeWrapper }: self:

let
  # Untouched npm-downloaded packages
  nodePkgs = pkgs.callPackage ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
with self; with elmLib; {
  inherit (nodePkgs) elm-live elm-upgrade elm-xref elm-analyse elm-git-install;

  elm-verify-examples =
    let
      patched = patchBinwrap [ elmi-to-json ] nodePkgs.elm-verify-examples // {
        meta = with lib; nodePkgs.elm-verify-examples.meta // {
          description = "Verify examples in your docs";
          homepage = "https://github.com/stoeffel/elm-verify-examples";
          license = licenses.bsd3;
          maintainers = [ maintainers.turbomack ];
        };
      };
    in
    patched.override (old: {
      preRebuild = (old.preRebuild or "") + ''
        # This should not be needed (thanks to binwrap* being nooped) but for some reason it still needs to be done
        # in case of just this package
        # TODO: investigate, same as for elm-coverage below
        sed 's/\"install\".*/\"install\":\"echo no-op\",/g' --in-place node_modules/elmi-to-json/package.json
      '';
    });

  elm-coverage =
    let
      patched = patchNpmElm (patchBinwrap [ elmi-to-json ] nodePkgs.elm-coverage);
    in
    patched.override (old: {
      # Symlink Elm instrument binary
      preRebuild = (old.preRebuild or "") + ''
        # Noop custom installation script
        sed 's/\"install\".*/\"install\":\"echo no-op\"/g' --in-place package.json

        # This should not be needed (thanks to binwrap* being nooped) but for some reason it still needs to be done
        # in case of just this package
        # TODO: investigate
        sed 's/\"install\".*/\"install\":\"echo no-op\",/g' --in-place node_modules/elmi-to-json/package.json
      '';
      postInstall = (old.postInstall or "") + ''
        mkdir -p unpacked_bin
        ln -sf ${elm-instrument}/bin/elm-instrument unpacked_bin/elm-instrument
      '';
      meta = with lib; nodePkgs.elm-coverage.meta // {
        description = "Work in progress - Code coverage tooling for Elm";
        homepage = "https://github.com/zwilias/elm-coverage";
        license = licenses.bsd3;
        maintainers = [ maintainers.turbomack ];
      };
    });

  create-elm-app = patchNpmElm
    nodePkgs.create-elm-app // {
    meta = with lib; nodePkgs.create-elm-app.meta // {
      description = "Create Elm apps with no build configuration";
      homepage = "https://github.com/halfzebra/create-elm-app";
      license = licenses.mit;
      maintainers = [ maintainers.turbomack ];
    };
  };

  elm-graphql =
    nodePkgs."@dillonkearns/elm-graphql" // {
      meta = with lib; nodePkgs."@dillonkearns/elm-graphql".meta // {
        description = " Autogenerate type-safe GraphQL queries in Elm.";
        license = licenses.bsd3;
        maintainers = [ maintainers.pedrohlc ];
      };
    };

  elm-review =
    nodePkgs.elm-review // {
      meta = with lib; nodePkgs.elm-review.meta // {
        description = "Analyzes Elm projects, to help find mistakes before your users find them";
        homepage = "https://package.elm-lang.org/packages/jfmengels/elm-review/${nodePkgs.elm-review.version}";
        license = licenses.bsd3;
        maintainers = [ maintainers.turbomack ];
      };
    };

  elm-language-server = nodePkgs."@elm-tooling/elm-language-server" // {
    meta = with lib; nodePkgs."@elm-tooling/elm-language-server".meta // {
      description = "Language server implementation for Elm";
      homepage = "https://github.com/elm-tooling/elm-language-server";
      license = licenses.mit;
      maintainers = [ maintainers.turbomack ];
    };
  };

  elm-spa = nodePkgs."elm-spa".overrideAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper old.nodejs.pkgs.node-gyp-build ];

      meta = with lib; nodePkgs."elm-spa".meta // {
        description = "A tool for building single page apps in Elm";
        homepage = "https://www.elm-spa.dev/";
        license = licenses.bsd3;
        maintainers = [ maintainers.ilyakooo0 ];
      };
    }
  );

  elm-optimize-level-2 = nodePkgs."elm-optimize-level-2" // {
    meta = with lib; nodePkgs."elm-optimize-level-2".meta // {
      description = "A second level of optimization for the Javascript that the Elm Compiler produces";
      homepage = "https://github.com/mdgriffith/elm-optimize-level-2";
      license = licenses.bsd3;
      maintainers = [ maintainers.turbomack ];
    };
  };

  elm-pages = import ./elm-pages { inherit nodePkgs pkgs lib makeWrapper; };

  elm-land =
    let
      patched = patchNpmElm nodePkgs.elm-land;
    in
    patched.override (old: {
      meta = with lib; nodePkgs."elm-land".meta // {
        description = "A production-ready framework for building Elm applications.";
        homepage = "https://elm.land/";
        license = licenses.bsd3;
        maintainers = [ maintainers.zupo ];
      };
    }
    );

  elm-doc-preview = nodePkgs."elm-doc-preview".overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ old.nodejs.pkgs.node-gyp-build ];
  });
}
