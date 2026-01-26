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
  pname = "llvm-tblgen";

  src' =
    if monorepoSrc != null then
      runCommand "${pname}-src-${version}" { } ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/third-party "$out"
        cp -r ${monorepoSrc}/llvm "$out"
        cp -r ${monorepoSrc}/clang "$out"
        cp -r ${monorepoSrc}/clang-tools-extra "$out"
        cp -r ${monorepoSrc}/mlir "$out"
      ''
    else
      src;

  # List of tablegen targets.
  targets = [
    "clang-tblgen"
    "llvm-tblgen"
    "clang-tidy-confusable-chars-gen"
    "mlir-tblgen"
  ]
  ++ lib.optionals (lib.versionOlder release_version "20") [
    "clang-pseudo-gen" # Removed in LLVM 20 @ ed8f78827895050442f544edef2933a60d4a7935.
  ];

  self = stdenv.mkDerivation (finalAttrs: {
    inherit pname version patches;

    src = src';
    sourceRoot = "${finalAttrs.src.name}/llvm";

    __structuredAttrs = true;

    postPatch = ''
      (
        cd ../clang
        chmod u+rwX -R .
        for p in ${toString clangPatches}
        do
          patch -p1 < $p
        done
      )
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
      "-DLLVM_ENABLE_PROJECTS=${
        lib.concatStringsSep ";" [
          "llvm"
          "clang"
          "clang-tools-extra"
          "mlir"
        ]
      }"
    ]
    ++ devExtraCmakeFlags;

    ninjaFlags = targets;

    inherit targets;

    installPhase = ''
      mkdir -p $out/bin
      cp "''${targets[@]/#/bin/}" $out/bin
    '';
  });
in
self
