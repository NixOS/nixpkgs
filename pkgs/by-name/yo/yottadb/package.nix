{ callPackage }:

# NOTE: `ydbCommitRef` MUST be a commit, since it is used in `YDB_RELEASE_STAMP`
# This is why we are fetching the source by the commit hash and not simply by the version tag.

rec {
  latest = r202;

  r202 = callPackage ./build-from-source.nix {
    ydbVersion = "2.02";
    ydbCommitRef = "6b6853170ca3b3bf71176d2802573d4410d83dad"; # r2.02 tag
    ydbNixHash = "sha256-CpwzEhkusyA5veiKzMdA7fZVDnpHKAeXR1ukcfVVazg=";
  };
}

