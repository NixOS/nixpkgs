{
  cmake,
  devExtraCmakeFlags ? [ ],
  lib,
  llvm_meta,
  monorepoSrc ? null,
  ninja,
  patches ? [ ],
  python3,
  updateAutotoolsGnuConfigScriptsHook,
  release_version,
  runCommand,
  src ? null,
  stdenv,
  version,
  clangPatches,
  # List of tablegen targets.
  targets ? [
    "clang-tblgen"
    "clang-tidy-confusable-chars-gen"
    "llvm-tblgen"
    "mlir-tblgen"
  ]
  ++ lib.optionals (lib.versionOlder release_version "20") [
    "clang-pseudo-gen" # Removed in LLVM 20 @ ed8f78827895050442f544edef2933a60d4a7935.
  ],
}:

let
  # This is a synthetic package which is not an official part of the llvm-project.
  # See https://github.com/NixOS/nixpkgs/pull/362384 for discussion.
  #
  # LLVM has tools that run at build time. In native builds, these are
  # built as a part of the usual build, but in cross builds they need to
  # come from buildPackages.
  #
  # In many scenarios this is a small problem because LLVM from
  # buildPackages is already available as a build; but if cross building a
  # version of LLVM which is not available (e.g. a new git commit of LLVM)
  # this results in two builds of LLVM and clang, one native and one for the
  # cross.
  #
  # Full builds of LLVM are expensive; and unnecessary in this scenario. We
  # don't need a native LLVM, only a native copy of the tools which run at
  # build time. This is only tablegen and related tooling, which are cheap
  # to build.
  inherit (lib)
    concatMap
    concatStringsSep
    naturalSort
    subtractLists
    unique
    ;

  pname = "llvm-tblgen";

  targetsSorted = naturalSort targets;

  requiredProjectsPerTarget = {
    "clang-tblgen" = [ "clang" ];
    "lldb-tblgen" = [
      "clang"
      "lldb"
    ];
    "llvm-tblgen" = [ "llvm" ];
    "mlir-tblgen" = [ "mlir" ];
    "clang-pseudo-gen" = [
      "clang"
      "clang-tools-extra"
    ];
    "clang-tidy-confusable-chars-gen" = [
      "clang"
      "clang-tools-extra"
    ];
  };

  projects = unique (naturalSort (concatMap (t: requiredProjectsPerTarget."${t}") targetsSorted));

  src' =
    if monorepoSrc != null then
      let
        requiredDirs = [
          "cmake"
          "third-party"
          "llvm"
        ];
        sourcePaths = concatStringsSep " " (
          map (p: "${monorepoSrc}/${p}") (requiredDirs ++ (subtractLists requiredDirs projects))
        );
      in
      runCommand "${pname}-src-${version}" { } ''
        mkdir -p "$out"
        cp -r -t "$out" ${sourcePaths}
      ''
    else
      src;

  self = stdenv.mkDerivation (finalAttrs: {
    inherit pname version patches;

    src = src';
    sourceRoot = "${finalAttrs.src.name}/llvm";

    __structuredAttrs = true;

    postPatch = ''
      if [ -d ../clang ]; then
        (
          cd ../clang
          chmod u+rwX -R .
          for p in ${toString clangPatches}
          do
            patch -p1 < $p
          done
        )
      fi
    '';

    nativeBuildInputs = [
      cmake
      ninja
      python3

      # while this is not an autotools build, it still includes a config.guess
      # this is needed until scripts are updated to not use /usr/bin/uname on FreeBSD native
      updateAutotoolsGnuConfigScriptsHook
    ];

    cmakeFlags = [
      # Projects with tablegen-like tools.
      "-DLLVM_ENABLE_PROJECTS=${concatStringsSep ";" projects}"
    ]
    ++ devExtraCmakeFlags;

    ninjaFlags = finalAttrs.targets;

    targets = targetsSorted;

    installPhase = ''
      mkdir -p $out/bin
      cp "''${targets[@]/#/bin/}" $out/bin
    '';
  });
in
self
