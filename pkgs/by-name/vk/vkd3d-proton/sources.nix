{ fetchFromGitHub }:

{
  vkd3d-proton =
    let
      self = {
        pname = "vkd3d-proton";
        version = "2.14.1";

        src = fetchFromGitHub {
          owner = "HansKristian-Work";
          repo = "vkd3d-proton";
          tag = "v${self.version}";
          fetchSubmodules = true;
          #
          # Some files are filled by using Git commands; it requires deepClone.
          # More info at `checkout_ref` function in nix-prefetch-git.
          # However, `.git` is a bit nondeterministic (and Git itself makes no
          # guarantees whatsoever).
          # Then, in order to enhance reproducibility, what we will do here is:
          #
          # - Execute the desired Git commands;
          # - Save the obtained info into files;
          # - Remove `.git` afterwards.
          #
          deepClone = true;
          postFetch = ''
            cd $out
            mkdir -p .nixpkgs-auxfiles/
            git describe --always --exclude='*' --abbrev=15 --dirty=0 > .nixpkgs-auxfiles/vkd3d_build
            git describe --always --tags --dirty=+ > .nixpkgs-auxfiles/vkd3d_version
            find $out -name .git -print0 | xargs -0 rm -fr
          '';
          hash = "sha256-8YA/I5UL6G5v4uZE2qKqXzHWeZxg67jm20rONKocvvE=";
        };
      };
    in
    self;
}
