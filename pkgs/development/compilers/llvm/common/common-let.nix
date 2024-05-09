{ lib
, fetchFromGitHub ? null
, release_version ? null
, gitRelease ? null
, officialRelease ? null
, monorepoSrc' ? null
}:

rec {
  llvm_meta = {
    license = lib.licenses.ncsa;
    maintainers = lib.teams.llvm.members;

    # See llvm/cmake/config-ix.cmake.
    platforms =
      lib.platforms.aarch64 ++
      lib.platforms.arm ++
      lib.platforms.mips ++
      lib.platforms.power ++
      lib.platforms.s390x ++
      lib.platforms.wasi ++
      lib.platforms.x86 ++
      lib.optionals (lib.versionAtLeast release_version "7") lib.platforms.riscv ++
      lib.optionals (lib.versionAtLeast release_version "14") lib.platforms.m68k;
  };

  releaseInfo =
    if gitRelease != null then rec {
      original = gitRelease;
      release_version = original.version;
      version = gitRelease.rev-version;
    } else rec {
      original = officialRelease;
      release_version = original.version;
      version =
        if original ? candidate then
          "${release_version}-${original.candidate}"
        else
          release_version;
    };

  monorepoSrc =
    if monorepoSrc' != null then
      monorepoSrc'
    else
      let
        sha256 = releaseInfo.original.sha256;
        rev =
          if gitRelease != null then
            gitRelease.rev
          else
            "llvmorg-${releaseInfo.version}";
      in
      fetchFromGitHub {
        owner = "llvm";
        repo = "llvm-project";
        inherit rev sha256;
      };

}
