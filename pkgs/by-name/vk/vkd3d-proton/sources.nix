{ fetchFromGitHub }:

{
  vkd3d-proton =
    let
      self = {
        pname = "vkd3d-proton";
        version = "2.13";

        src = fetchFromGitHub {
          owner = "HansKristian-Work";
          repo = "vkd3d-proton";
          rev = "v${self.version}";
          fetchSubmodules = true;
          #
          # Some files are filled by using Git commands; it requires deepClone.
          # More info at `checkout_ref` function in nix-prefetch-git.
          # However, `.git` is a bit nondeterministic (and Git itself makes no
          # guarrantees whatsoever).
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
          hash = "sha256-dJYQ6pJdfRQwr8OrxxpWG6YMfeTXqzTrHXDd5Ecxbi8=";
        };
      };
    in
    self;
}
