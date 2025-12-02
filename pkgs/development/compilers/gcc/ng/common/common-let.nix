{
  lib,
  fetchurl ? null,
  fetchgit ? null,
  release_version ? null,
  gitRelease ? null,
  officialRelease ? null,
  monorepoSrc' ? null,
  version ? null,
}@args:

rec {
  gcc_meta = {
    license = with lib.licenses; [ gpl3Plus ];
    teams = [ lib.teams.gcc ];
  };

  releaseInfo =
    if gitRelease != null then
      rec {
        original = gitRelease;
        release_version = args.version or original.version;
        version = gitRelease.rev-version;
      }
    else
      rec {
        original = officialRelease;
        release_version = args.version or original.version;
        version =
          if original ? candidate then "${release_version}-${original.candidate}" else release_version;
      };

  monorepoSrc =
    if monorepoSrc' != null then
      monorepoSrc'
    else if gitRelease != null then
      fetchgit {
        url = "https://gcc.gnu.org/git/gcc.git";
        inherit (gitRelease) rev;
        hash = releaseInfo.original.sha256;
      }
    else
      fetchurl {
        url = "mirror://gcc/releases/gcc-${releaseInfo.version}/gcc-${releaseInfo.version}.tar.xz";
        hash = releaseInfo.original.sha256;
      };
}
