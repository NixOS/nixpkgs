{
  lib,
  callPackage,
  writeText,
  symlinkJoin,
  darwin,
  clang,
  llvm,
  tools ? callPackage ./tools.nix {
    inherit (stdenv)
      hostPlatform
      buildPlatform
      ;
  },
  stdenv,
  stdenvNoCC,
  dart,
  fetchgit,
  runCommand,
  llvmPackages,
  patchelf,
  openbox,
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
  python312,
  gitMinimal,
  version,
  flutterVersion,
  dartSdkVersion,
  swiftshaderHash,
  swiftshaderRev,
  hashes,
  patches,
  url,
  runtimeMode ? "release",
  isOptimized ? runtimeMode != "debug",
}:
let
  expandSingleDep =
    dep: lib.optionals (lib.isDerivation dep) ([ dep ] ++ map (output: dep.${output}) dep.outputs);

  expandDeps = deps: lib.flatten (map expandSingleDep deps);

  constants = callPackage ./constants.nix { platform = stdenv.targetPlatform; };

  python3 = python312;

  src = callPackage ./source.nix {
    inherit
      tools
      flutterVersion
      version
      hashes
      url
      ;
    inherit (stdenv)
      hostPlatform
      buildPlatform
      targetPlatform
      ;
  };

  swiftshader = fetchgit {
    url = "https://swiftshader.googlesource.com/SwiftShader.git";
    hash = swiftshaderHash;
    rev = swiftshaderRev;

    postFetch = ''
      rm -rf $out/third_party/llvm-project
    '';
  };

  llvm = symlinkJoin {
    name = "llvm";
    paths = [
      clang
      llvmPackages.llvm
    ];
  };

  outName = "host_${runtimeMode}${lib.optionalString (!isOptimized) "_unopt"}";

  dartPath = "${
    if (lib.versionAtLeast flutterVersion "3.23") then "flutter/third_party" else "third_party"
  }/dart";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flutter-engine-${runtimeMode}${lib.optionalString (!isOptimized) "-unopt"}";
  inherit
    version
    runtimeMode
    patches
    isOptimized
    dartSdkVersion
    src
    outName
    swiftshader
    ;

  setOutputFlags = false;
  doStrip = isOptimized;

  toolchain = symlinkJoin {
    name = "flutter-engine-toolchain-${version}";

    paths =
      expandDeps (
        lib.optionals (stdenv.hostPlatform.isLinux) [
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
        ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
          clang
          llvm
        ]
      )
      ++ [
        stdenv.cc.libc_dev
        stdenv.cc.libc_lib
      ];

    # Needed due to Flutter expecting everything to be relative to $out
    # and not true absolute path (ie relative to "/").
    postBuild = ''
      mkdir -p $(dirname $(dirname "$out/$out"))
      ln -s $(dirname "$out") $out/$(dirname "$out")
    '';
  };

  NIX_CFLAGS_COMPILE = [
    "-I${finalAttrs.toolchain}/include"
  ]
  ++ lib.optional (!isOptimized) "-U_FORTIFY_SOURCE"
  ++ lib.optionals (lib.versionAtLeast flutterVersion "3.35") [
    "-Wno-macro-redefined"
    "-Wno-error=macro-redefined"
  ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.xorgserver
    openbox
  ];

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pyyaml
      ]
    ))
    (tools.vpython python3)
    gitMinimal
    pkg-config
    ninja
    dart
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ patchelf ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    darwin.system_cmds
    darwin.xcode
    tools.xcode-select
  ]
  ++ lib.optionals (stdenv.cc.libc ? bin) [ stdenv.cc.libc.bin ];

  buildInputs = [ gtk3 ];

  patchtools = [ "flutter/third_party/gn/gn" ];

  dontPatch = true;

  patchgit = [
    dartPath
    "flutter"
    "."
  ]
  ++ lib.optional (lib.versionAtLeast flutterVersion "3.21") "flutter/third_party/skia";

  postUnpack = ''
    pushd ${src.name}

    cp ${./pkg-config.py} src/build/config/linux/pkg-config.py

    cp -pr --reflink=auto $swiftshader src/flutter/third_party/swiftshader
    chmod -R u+w -- src/flutter/third_party/swiftshader

    ln -s ${llvmPackages.llvm.monorepoSrc} src/flutter/third_party/swiftshader/third_party/llvm-project

    mkdir -p src/flutter/buildtools/${constants.alt-platform}
    ln -s ${llvm} src/flutter/buildtools/${constants.alt-platform}/clang

    mkdir -p src/buildtools/${constants.alt-platform}
    ln -s ${llvm} src/buildtools/${constants.alt-platform}/clang

    mkdir -p src/${dartPath}/tools/sdks
    ln -s ${dart} src/${dartPath}/tools/sdks/dart-sdk

    ${lib.optionalString (stdenv.hostPlatform.isLinux) ''
      for patchtool in ''${patchtools[@]}; do
        patchelf src/$patchtool --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)
      done
    ''}

    for dir in ''${patchgit[@]}; do
      pushd src/$dir
      rm -rf .git
      git init
      git add .
      git config user.name "nobody"
      git config user.email "nobody@local.host"
      git commit -a -m "$dir" --quiet
      popd
    done

    dart src/${dartPath}/tools/generate_package_config.dart
    echo "${dartSdkVersion}" >src/${dartPath}/sdk/version

    rm -rf src/third_party/angle/.git
    python3 src/flutter/tools/pub_get_offline.py

    pushd src/flutter

    for p in ''${patches[@]}; do
      patch -p1 -i $p
    done

    popd
  ''
  # error: 'close_range' is missing exception specification 'noexcept(true)'
  + lib.optionalString (lib.versionAtLeast flutterVersion "3.35") ''
    substituteInPlace src/flutter/third_party/dart/runtime/bin/process_linux.cc \
      --replace-fail "(unsigned int first, unsigned int last, int flags)" "(unsigned int first, unsigned int last, int flags) noexcept(true)"
  ''
  + ''
    popd
  '';

  configureFlags = [
    "--no-prebuilt-dart-sdk"
    "--embedder-for-target"
    "--no-goma"
  ]
  ++ lib.optionals (stdenv.targetPlatform.isx86_64 == false) [
    "--linux"
    "--linux-cpu ${constants.alt-arch}"
  ]
  ++ lib.optional (!isOptimized) "--unoptimized"
  ++ lib.optional (runtimeMode == "debug") "--no-stripped"
  ++ lib.optional finalAttrs.finalPackage.doCheck "--enable-unittests"
  ++ lib.optional (!finalAttrs.finalPackage.doCheck) "--no-enable-unittests";

  # NOTE: Once https://github.com/flutter/flutter/issues/127606 is fixed, use "--no-prebuilt-dart-sdk"
  configurePhase = ''
    runHook preConfigure

    export PYTHONPATH=$src/src/build
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export PATH=${darwin.xcode}/Contents/Developer/usr/bin/:$PATH
  ''
  + ''
    python3 ./src/flutter/tools/gn $configureFlags \
      --runtime-mode $runtimeMode \
      --out-dir $out \
      --target-sysroot $toolchain \
      --target-dir $outName \
      --target-triple ${stdenv.targetPlatform.config} \
      --enable-fontconfig

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export TERM=dumb

    ${lib.optionalString (lib.versionAtLeast flutterVersion "3.29") ''
      # ValueError: ZIP does not support timestamps before 1980
      substituteInPlace src/flutter/build/zip.py \
        --replace-fail "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED)" "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED, strict_timestamps=False)"
    ''}

    ninja -C $out/out/$outName -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  # Tests are broken
  doCheck = false;
  checkPhase = ''
    ln -s $out/out src/out
    touch src/out/run_tests.log
    sh src/flutter/testing/run_tests.sh $outName
    rm src/out/run_tests.log
  '';

  installPhase = ''
    runHook preInstall

    rm -rf $out/out/$outName/{obj,exe.unstripped,lib.unstripped,zip_archives}
    rm $out/out/$outName/{args.gn,build.ninja,build.ninja.d,compile_commands.json,toolchain.ninja}
    find $out/out/$outName -name '*_unittests' -delete
    find $out/out/$outName -name '*_benchmarks' -delete
  ''
  + lib.optionalString (finalAttrs.finalPackage.doCheck) ''
    rm $out/out/$outName/{display_list_rendertests,flutter_tester}
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    dart = callPackage ./dart.nix { engine = finalAttrs.finalPackage; };
  };

  meta = {
    # Very broken on Darwin
    broken = stdenv.hostPlatform.isDarwin;
    description = "Flutter engine";
    homepage = "https://flutter.dev";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  }
  // lib.optionalAttrs (lib.versionOlder flutterVersion "3.22") { hydraPlatforms = [ ]; };
})
