{
  desktop-file-utils,
  python3,
  runCommand,
  writeText,
  vortex,
}:

runCommand "vortex-packaging-tests"
  {
    nativeBuildInputs = [
      desktop-file-utils
      (python3.withPackages (ps: [ ps.pyyaml ]))
    ];
    archives = writeText "vortex-git-archives.json" (
      builtins.toJSON (
        map (dep: {
          inherit (dep) repository revision;
          archive = toString dep.archive;
        }) vortex.gitDependencies
      )
    );
  }
  ''
    python ${./test-packaging.py} \
      --package ${vortex} \
      --source ${vortex.src} \
      --pins ${./pnpm-github-dependencies.json} \
      --helper ${./pnpm-github-lock.py} \
      --archives "$archives"
    touch "$out"
  ''
