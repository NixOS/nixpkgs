{
  lib,
  callPackage,
  writeText,
  symlinkJoin,
  targetPlatform,
  hostPlatform,
  darwin,
  clang,
  llvm,
  tools ? callPackage ./tools.nix { inherit hostPlatform; },
  stdenv,
  stdenvNoCC,
  runCommand,
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
  pkg-config,
  ninja,
  python3,
  git,
  version,
  flutterVersion,
  dartSdkVersion,
  hashes,
  patches,
  url,
  runtimeMode ? "release",
  isOptimized ? true,
}:
with lib;
let
  expandSingleDep =
    dep: lib.optionals (lib.isDerivation dep) ([ dep ] ++ map (output: dep.${output}) dep.outputs);

  expandDeps = deps: flatten (map expandSingleDep deps);

  constants = callPackage ./constants.nix { inherit targetPlatform; };

  src = callPackage ./source.nix {
    inherit
      tools
      version
      hashes
      url
      ;
  };
in
stdenv.mkDerivation {
  pname = "flutter-engine-${runtimeMode}${lib.optionalString (!isOptimized) "-unopt"}";
  inherit
    version
    runtimeMode
    patches
    isOptimized
    dartSdkVersion
    src;

  toolchain = symlinkJoin {
    name = "flutter-engine-toolchain-${version}";

    paths =
      expandDeps (
        optionals (stdenv.isLinux) [
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
        ]
        ++ optionals (stdenv.isDarwin) [
          clang
          llvm
        ]
      )
      ++ [
        stdenv.cc.libc_dev
        stdenv.cc.libc_lib
      ];

    postBuild = ''
      ln -s /nix $out/nix
    '';
  };

  nativeBuildInputs =
    [
      python3
      (tools.vpython python3)
      git
      pkg-config
      ninja
    ]
    ++ lib.optionals (stdenv.isLinux) [ patchelf ]
    ++ optionals (stdenv.isDarwin) [
      darwin.system_cmds
      darwin.xcode
      tools.xcode-select
    ]
    ++ lib.optionals (stdenv.cc.libc ? bin) [ stdenv.cc.libc.bin ];

  buildInputs = [ gtk3 ];

  patchtools =
    let
      buildtoolsPath =
        if lib.versionAtLeast flutterVersion "3.21" then "flutter/buildtools" else "buildtools";
    in
    [
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-apply-replacements"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-doc"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-format"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-include-fixer"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-refactor"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-scan-deps"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clang-tidy"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/clangd"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/dsymutil"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/find-all-symbols"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/lld"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-ar"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-bolt"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-cov"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-cxxfilt"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-debuginfod-find"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-dwarfdump"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-dwp"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-gsymutil"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-ifs"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-libtool-darwin"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-lipo"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-ml"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-mt"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-nm"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-objcopy"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-objdump"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-pdbutil"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-profdata"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-rc"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-readobj"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-size"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-symbolizer"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-undname"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm-xray"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/llvm"
      "${buildtoolsPath}/${constants.alt-platform}/clang/bin/sancov"
      "flutter/prebuilts/${constants.alt-platform}/dart-sdk/bin/dartaotruntime"
      "flutter/prebuilts/${constants.alt-platform}/dart-sdk/bin/dart"
      "flutter/third_party/gn/gn"
      "third_party/dart/tools/sdks/dart-sdk/bin/dart"
    ];

  dontPatch = true;

  patchgit = [
    "third_party/dart"
    "flutter"
    "."
  ] ++ lib.optional (lib.versionAtLeast flutterVersion "3.21") "flutter/third_party/skia";

  postUnpack = ''
    pushd ${src.name}
    ${lib.optionalString (stdenv.isLinux) ''
      for patchtool in ''${patchtools[@]}; do
        patchelf src/$patchtool --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
      done
    ''}

    for dir in ''${patchgit[@]}; do
      pushd src/$dir
      rev=$(cat .git/HEAD)
      rm -rf .git
      git init
      git add .
      git config user.name "nobody"
      git config user.email "nobody@local.host"
      git commit -a -m "$rev"
      popd
    done

    src/flutter/prebuilts/${constants.alt-platform}/dart-sdk/bin/dart src/third_party/dart/tools/generate_package_config.dart
    cp ${./pkg-config.py} src/build/config/linux/pkg-config.py
    echo "${dartSdkVersion}" >src/third_party/dart/sdk/version

    rm -rf src/third_party/angle/.git
    python3 src/flutter/tools/pub_get_offline.py

    pushd src/flutter

    for p in ''${patches[@]}; do
      patch -p1 -i $p
    done

    popd
    popd
  '';

  configureFlags =
    [
      "--no-prebuilt-dart-sdk"
      "--embedder-for-target"
      "--no-goma"
    ]
    ++ optionals (targetPlatform.isx86_64 == false) [
      "--linux"
      "--linux-cpu ${constants.alt-arch}"
    ];

  # NOTE: Once https://github.com/flutter/flutter/issues/127606 is fixed, use "--no-prebuilt-dart-sdk"
  configurePhase =
    ''
      runHook preConfigure

      export PYTHONPATH=$src/src/build
    ''
    + lib.optionalString stdenv.isDarwin ''
      export PATH=${darwin.xcode}/Contents/Developer/usr/bin/:$PATH
    ''
    + ''
      python3 ./src/flutter/tools/gn $configureFlags \
        --runtime-mode $runtimeMode \
        --out-dir $out \
        --target-sysroot $toolchain \
        --target-dir host_$runtimeMode${lib.optionalString (!isOptimized) "_unopt --unoptimized"} \
        --verbose

      runHook postConfigure
    '';

  buildPhase = ''
    runHook preBuild

    export TERM=dumb
    for tool in flatc scenec gen_snapshot dart impellerc shader_archiver gen_snapshot_product; do
      ninja -C $out/out/host_$runtimeMode${
        lib.optionalString (!isOptimized) "_unopt"
      } -j$NIX_BUILD_CORES $tool
      ${lib.optionalString (stdenv.isLinux) ''
        patchelf $out/out/host_$runtimeMode${
          lib.optionalString (!isOptimized) "_unopt"
        }/$tool --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
      ''}
    done

    ninja -C $out/out/host_$runtimeMode${lib.optionalString (!isOptimized) "_unopt"} -j$NIX_BUILD_CORES

    ${lib.optionalString (stdenv.isLinux) ''
      patchelf $out/out/host_$runtimeMode${
        lib.optionalString (!isOptimized) "_unopt"
      }/dart-sdk/bin/dartaotruntime \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
    ''}

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
    # Very broken on Darwin
    broken = stdenv.isDarwin;
    description = "The Flutter engine";
    homepage = "https://flutter.dev";
    maintainers = with maintainers; [ RossComputerGuy ];
    license = licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
