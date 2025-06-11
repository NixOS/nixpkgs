{ pkgs, lib }:

self:
pkgs.haskell.packages.ghc94.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) justStaticExecutables overrideCabal doJailbreak;
      elmPkgs = {
        /*
          The elm-format expression is updated via a script in the https://github.com/avh4/elm-format repo:
          `package/nix/build.sh`
        */
        elm-format = justStaticExecutables (
          overrideCabal (drv: {
            jailbreak = true;
            doHaddock = false;
            postPatch = ''
              mkdir -p ./generated
              cat <<EOHS > ./generated/Build_elm_format.hs
              module Build_elm_format where
              gitDescribe :: String
              gitDescribe = "${drv.version}"
              EOHS
            '';

            description = "Formats Elm source code according to a standard set of rules based on the official Elm Style Guide";
            homepage = "https://github.com/avh4/elm-format";
            license = lib.licenses.bsd3;
            maintainers = with lib.maintainers; [
              avh4
              turbomack
            ];
          }) (self.callPackage ./elm-format/elm-format.nix { })
        );

        elm-instrument = justStaticExecutables (
          overrideCabal
            (drv: {
              version = "unstable-2020-03-16";
              src = pkgs.fetchgit {
                url = "https://github.com/zwilias/elm-instrument";
                sha256 = "167d7l2547zxdj7i60r6vazznd9ichwc0bqckh3vrh46glkz06jv";
                rev = "63e15bb5ec5f812e248e61b6944189fa4a0aee4e";
                fetchSubmodules = true;
              };
              patches = [
                # Update code after breaking change in optparse-applicative
                # https://github.com/zwilias/elm-instrument/pull/5
                (pkgs.fetchpatch {
                  name = "update-optparse-applicative.patch";
                  url = "https://github.com/mdevlamynck/elm-instrument/commit/c548709d4818aeef315528e842eaf4c5b34b59b4.patch";
                  sha256 = "0ln7ik09n3r3hk7jmwwm46kz660mvxfa71120rkbbaib2falfhsc";
                })
              ];

              prePatch = ''
                sed "s/desc <-.*/let desc = \"${drv.version}\"/g" Setup.hs --in-place
              '';
              jailbreak = true;
              # Tests are failing because of missing instances for Eq and Show type classes
              doCheck = false;

              description = "Instrument Elm code as a preprocessing step for elm-coverage";
              homepage = "https://github.com/zwilias/elm-instrument";
              license = lib.licenses.bsd3;
              maintainers = [ lib.maintainers.turbomack ];
            })
            (
              self.callPackage ./elm-instrument {
                # elm-instrument's tests depend on an old version of elm-format, but we set doCheck to false for other reasons above
                elm-format = null;
              }
            )
        );
      };

      fixHaddock = overrideCabal (_: {
        configureFlags = [ "--ghc-option=-Wno-error=unused-packages" ];
        doHaddock = false;
      });
    in
    elmPkgs
    // {
      inherit elmPkgs;

      # Needed for elm-format
      avh4-lib = fixHaddock (doJailbreak (self.callPackage ./elm-format/avh4-lib.nix { }));
      elm-format-lib = fixHaddock (doJailbreak (self.callPackage ./elm-format/elm-format-lib.nix { }));
      elm-format-test-lib = fixHaddock (self.callPackage ./elm-format/elm-format-test-lib.nix { });
      elm-format-markdown = fixHaddock (self.callPackage ./elm-format/elm-format-markdown.nix { });

      # elm-instrument needs this
      indents = self.callPackage ./indents { };
    };
}
