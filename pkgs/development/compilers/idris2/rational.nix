{ fetchFromGitea, idris2Packages }:

# Assuming the previous example lives in `lsp-lib.nix`:
let rationalPkg = idris2Packages.buildIdris {
      ipkgName = "idris2-rational";
      version = "2024-06-29";
      src = fetchFromGitea {
         domain = "git.envs.net";
         owner = "iacore";
         repo = "idris2-rational";
         rev = "main";
         hash = "sha256-0000000000000000000000000000000000000000000=";
      };
      idrisLibraries = [ ];
    };
in rationalPkg.library
