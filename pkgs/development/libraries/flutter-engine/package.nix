{ lib,
  callPackage,
  writeText,
  symlinkJoin,
  cacert,
  targetPlatform,
  hostPlatform,
  tools ? callPackage ./tools.nix { inherit hostPlatform; },
  stdenv,
  stdenvNoCC,
  runCommand,
  fetchurl,
  patchelf,
  xorg,
  libglvnd,
  libepoxy,
  wayland,
  freetype,
  pango,
  glib,
  harfbuzz,
  cairo,
  gdk-pixbuf,
  at-spi2-atk,
  zlib,
  gtk3,
  curl,
  pkg-config,
  ninja,
  python3,
  git,
  version,
  dartVersion,
  hash,
  url
}:
with lib;
let
  expandSingleDep = dep: if lib.isDerivation dep then
    ([ dep ] ++ map (output: dep.${output}) dep.outputs)
  else [];

  expandDeps = deps: flatten (map expandSingleDep deps);

  constants = callPackage ./constants.nix {
    inherit targetPlatform;
  };

  git-revision = writeText "git-revision.py" ''
    #!/usr/bin/env python3

    import sys
    import subprocess
    import os
    import argparse

    def get_repository_version(repository):
      'Returns the Git HEAD for the supplied repository path as a string.'
      if not os.path.exists(repository):
        raise IOError('path does not exist')

      with open(os.path.join(repository, '.git', 'HEAD'), 'r') as head:
        return head.read().strip()

    def main():
      parser = argparse.ArgumentParser()

      parser.add_argument(
        '--repository',
        action='store',
        help='Path to the Git repository.',
        required=True
      )

      args = parser.parse_args()
      repository = os.path.abspath(args.repository)
      version = get_repository_version(repository)
      print(version.strip())

      return 0

    if __name__ == '__main__':
      sys.exit(main())
  '';
in
stdenv.mkDerivation {
  pname = "flutter-engine";
  inherit version;

  src = runCommand "flutter-engine-source-${version}" {
    pname = "flutter-engine-source";
    inherit version;

    inherit (tools) depot_tools;

    nativeBuildInputs = [
      curl
      pkg-config
      git
      tools.cipd
      (python3.withPackages (ps: with ps; [
        httplib2
        six
      ]))
    ];

    gclient = writeText "flutter-engine-${version}.gclient" ''
      solutions = [{
        "managed": False,
        "name": "src/flutter",
        "url": "${url}",
      }]
    '';

    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    DEPOT_TOOLS_UPDATE = "0";
    DEPOT_TOOLS_COLLECT_METRICS = "0";
    PYTHONDONTWRITEBYTECODE = "1";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = hash.${targetPlatform.system};
  } ''
    source ${../../../build-support/fetchgit/deterministic-git}
    export -f clean_git
    export -f make_deterministic_repo

    mkdir -p $out
    cp $gclient $out/.gclient
    cd $out

    export PATH=$PATH:$depot_tools
    python3 $depot_tools/gclient.py sync --no-history --shallow --nohooks
    find $out -name '.git' -exec dirname {} \; | xargs bash -c 'make_deterministic_repo $@' _
    find $out -path '*/.git/*' ! -name 'HEAD' -prune -exec rm -rf {} \;
    find $out -name '.git' -exec mkdir {}/logs \;
    find $out -name '.git' -exec cp {}/HEAD {}/logs/HEAD \;

    python3 src/build/linux/sysroot_scripts/install-sysroot.py --arch=${constants.arch}

    rm -rf $out/.cipd $out/.gclient $out/.gclient_entries $out/.gclient_previous_custom_vars $out/.gclient_previous_sync_commits
  '';

  toolchain = symlinkJoin {
    name = "flutter-engine-toolchain-${version}";

    paths = (expandDeps [
      gtk3
      wayland
      libepoxy
      libglvnd
      freetype
      at-spi2-atk
      glib
      gdk-pixbuf
      harfbuzz
      pango
      cairo
      xorg.libxcb
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXrender
      xorg.libXinerama
      xorg.libXi
      xorg.libXext
      xorg.libXfixes
      xorg.libXxf86vm
      xorg.xorgproto
      zlib
    ]) ++ [
      stdenv.cc.libc_dev
      stdenv.cc.libc_lib
    ];

    postBuild = ''
      ln -s /nix $out/nix
    '';
  };

  nativeBuildInputs = [
    python3
    patchelf
    tools.vpython
    git
    pkg-config
    ninja
    stdenv.cc.libc.bin
  ];

  buildInputs = [
    gtk3
  ];

  patchtools = [
    "buildtools/${constants.alt-platform}/clang/bin/clang-apply-replacements"
    "buildtools/${constants.alt-platform}/clang/bin/clang-doc"
    "buildtools/${constants.alt-platform}/clang/bin/clang-format"
    "buildtools/${constants.alt-platform}/clang/bin/clang-include-fixer"
    "buildtools/${constants.alt-platform}/clang/bin/clang-refactor"
    "buildtools/${constants.alt-platform}/clang/bin/clang-scan-deps"
    "buildtools/${constants.alt-platform}/clang/bin/clang-tidy"
    "buildtools/${constants.alt-platform}/clang/bin/clangd"
    "buildtools/${constants.alt-platform}/clang/bin/dsymutil"
    "buildtools/${constants.alt-platform}/clang/bin/find-all-symbols"
    "buildtools/${constants.alt-platform}/clang/bin/lld"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-ar"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-bolt"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-cov"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-cxxfilt"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-debuginfod-find"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-dwarfdump"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-dwp"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-gsymutil"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-ifs"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-libtool-darwin"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-lipo"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-ml"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-mt"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-nm"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-objcopy"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-objdump"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-pdbutil"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-profdata"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-rc"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-readobj"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-size"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-symbolizer"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-undname"
    "buildtools/${constants.alt-platform}/clang/bin/llvm-xray"
    "buildtools/${constants.alt-platform}/clang/bin/llvm"
    "buildtools/${constants.alt-platform}/clang/bin/sancov"
    "flutter/prebuilts/${constants.alt-platform}/dart-sdk/bin/dart"
    "flutter/third_party/gn/gn"
    "third_party/dart/tools/sdks/dart-sdk/bin/dart"
  ];

  patches = [
  ];

  patchgit = [
    "third_party/dart"
    "flutter"
    "."
  ];

  runtimeModes = [
    "debug"
    "profile"
    "release"
    "jit_release"
  ];

  postUnpack =
  let
    fixPango = fetchurl {
      url = "https://patch-diff.githubusercontent.com/raw/flutter/engine/pull/45098.diff";
      sha256 = "sha256-FYbC8tGfJLfGkA79GD4O+C7iNL/0NYfgTx4+p/UJljs=";
    };
  in ''
    pushd flutter-engine-source-$version
    for patchtool in ''${patchtools[@]}; do
      patchelf src/$patchtool --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
    done

    for dir in ''${patchgit[@]}; do
      pushd src/$dir
      rev=$(cat .git/HEAD)
      rm -rf .git
      git init
      git add .
      mkdir -p .git/logs
      echo $rev >.git/logs/HEAD
      echo "# pack-refs with: peeled fully-peeled sorted" >.git/packed-refs
      echo "$rev refs/remotes/origin/master" >>.git/packed-refs
      popd
    done

    src/flutter/prebuilts/${constants.alt-platform}/dart-sdk/bin/dart src/third_party/dart/tools/generate_package_config.dart
    cp ${git-revision} src/flutter/build/git_revision.py
    cp ${./pkg-config.py} src/build/config/linux/pkg-config.py
    echo "${dartVersion}" >src/third_party/dart/sdk/version

    rm -rf src/third_party/angle/.git
    python3 src/flutter/tools/pub_get_offline.py

    pushd src/flutter
    patch -Np1 -i ${fixPango}
    popd
    popd
  '';

  configureFlags = [
    "--no-prebuilt-dart-sdk"
    "--embedder-for-target"
    "--no-goma"
  ] ++ (optionals (targetPlatform.isx86_64 == false) [
    "--linux"
    "--linux-cpu ${constants.alt-arch}"
  ]);

  # NOTE: Once https://github.com/flutter/flutter/issues/127606 is fixed, use "--no-prebuilt-dart-sdk"
  configurePhase = ''
    runHook preConfigure

    for mode in ''${runtimeModes[@]}; do
      python3 ./src/flutter/tools/gn $configureFlags --runtime-mode $mode --out-dir $out --target-sysroot $toolchain --target-dir host_$mode
      python3 ./src/flutter/tools/gn $configureFlags --runtime-mode $mode --out-dir $out --target-sysroot $toolchain --target-dir host_''${mode}_unopt --unoptimized
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export TERM=dumb
    for dir in $out/out/*; do
      for tool in flatc scenec gen_snapshot dart blobcat impellerc; do
        ninja -C $dir -j$NIX_BUILD_CORES $tool
        patchelf $dir/$tool --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
      done

      ninja -C $dir -j$NIX_BUILD_CORES
    done

    runHook postBuild
  '';

  # Link sources so we can set $FLUTTER_ENGINE to this derivation
  installPhase = ''
    runHook preInstall

    for dir in $(find $src/src -mindepth 1 -maxdepth 1); do
      ln -sf $dir $out/$(basename $dir)
    done

    runHook postInstall
  '';

  meta = {
    description = "The Flutter engine";
    homepage = "https://flutter.dev";
    maintainers = with maintainers; [ RossComputerGuy ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
