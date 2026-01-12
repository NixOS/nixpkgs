{
  lib,
  callPackage,
  fetchurl,
  bash,
  symlinkJoin,
  darwin,
  clang,
  tools ? callPackage ./tools.nix {
    inherit (stdenv)
      hostPlatform
      buildPlatform
      ;
  },
  stdenv,
  dart,
  fetchgit,
  llvmPackages,
  patchelf,
  gn,
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
  constants = callPackage ./constants.nix { platform = stdenv.targetPlatform; };

  python3 = python312;

  src = callPackage ./source.nix {
    inherit
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
      rm --recursive --force $out/third_party/llvm-project
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

  dartPath = "flutter/third_party/dart";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flutter-engine-${runtimeMode}${lib.optionalString (!isOptimized) "-unopt"}";
  inherit version src patches;

  setOutputFlags = false;
  doStrip = isOptimized;

  toolchain = symlinkJoin {
    name = "flutter-engine-toolchain-${version}";

    paths =
      lib.flatten (
        map (dep: lib.optionals (lib.isDerivation dep) ([ dep ] ++ map (output: dep.${output}) dep.outputs))
          (
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
      )
      ++ [
        stdenv.cc.libc_dev
        stdenv.cc.libc_lib
      ];

    # Needed due to Flutter expecting everything to be relative to $out
    # and not true absolute path (ie relative to "/").
    postBuild = ''
      mkdir --parents $(dirname $(dirname "$out/$out"))
      ln --symbolic $(dirname "$out") $out/$(dirname "$out")
    '';
  };

  NIX_CFLAGS_COMPILE = [
    "-I${finalAttrs.toolchain}/include"
    "-O2"
    "-Wno-error"
    "-Wno-absolute-value"
    "-Wno-implicit-float-conversion"
  ]
  ++ lib.optional (!isOptimized) "-U_FORTIFY_SOURCE";

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

  buildInputs = [
    gtk3
    libepoxy
  ];

  dontPatch = true;

  env.patchgit = toString [
    dartPath
    "flutter"
    "."
    "flutter/third_party/skia"
  ];

  postUnpack =
    lib.optionalString (lib.versionAtLeast flutterVersion "3.38") ''
      chmod +w .
      mkdir --parents bin/internal
      echo '#!${lib.getExe bash}' > bin/internal/content_aware_hash.sh
      echo 'echo 1111111111111111111111111111111111111111' >> bin/internal/content_aware_hash.sh
      chmod +x bin/internal/content_aware_hash.sh
    ''
    + ''
      pushd ${finalAttrs.src.name}

      cp ${
        fetchurl {
          url = "https://raw.githubusercontent.com/chromium/chromium/631a813125b886a52274653144019fd1681a0e97/build/config/linux/pkg-config.py";
          hash = "sha256-9coRpgCewlkFXSGrMVkudaZUll0IFc9jDRBP+2PloOI=";
        }
      } src/build/config/linux/pkg-config.py

      cp --preserve=mode,ownership,timestamps --recursive --reflink=auto ${swiftshader} src/flutter/third_party/swiftshader
      chmod --recursive u+w -- src/flutter/third_party/swiftshader

      ln --symbolic ${llvmPackages.llvm.monorepoSrc} src/flutter/third_party/swiftshader/third_party/llvm-project

      mkdir --parents src/flutter/buildtools/${constants.alt-platform}
      ln --symbolic ${llvm} src/flutter/buildtools/${constants.alt-platform}/clang

      mkdir --parents src/buildtools/${constants.alt-platform}
      ln --symbolic ${llvm} src/buildtools/${constants.alt-platform}/clang

      mkdir --parents src/${dartPath}/tools/sdks
      ln --symbolic ${dart} src/${dartPath}/tools/sdks/dart-sdk

      mkdir --parents src/flutter/third_party/gn/
      ln --symbolic --force ${lib.getExe gn} src/flutter/third_party/gn/gn

      for dir in ''${patchgit[@]}; do
        pushd src/$dir
        rm --recursive --force .git
        git init
        git add .
        git config user.name "nobody"
        git config user.email "nobody@local.host"
        git commit --all --message="$dir" --quiet
        popd
      done

      dart src/${dartPath}/tools/generate_package_config.dart
      echo "${dartSdkVersion}" >src/${dartPath}/sdk/version
      python3 src/flutter/third_party/dart/tools/generate_sdk_version_file.py
      rm --recursive --force src/third_party/angle/.git
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
    "--no-dart-version-git-info"
  ]
  ++ lib.optionals (stdenv.targetPlatform.isx86_64 == false) [
    "--linux"
    "--linux-cpu ${constants.alt-arch}"
  ]
  ++ lib.optional (!isOptimized) "--unoptimized"
  ++ lib.optional (runtimeMode == "debug") "--no-stripped"
  ++ lib.optional finalAttrs.finalPackage.doCheck "--enable-unittests"
  ++ lib.optional (!finalAttrs.finalPackage.doCheck) "--no-enable-unittests";

  configurePhase = ''
    runHook preConfigure

    export PYTHONPATH=$src/src/build
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export PATH=${darwin.xcode}/Contents/Developer/usr/bin/:$PATH
  ''
  + ''
    python3 ./src/flutter/tools/gn $configureFlags \
      --runtime-mode ${runtimeMode} \
      --out-dir $out \
      --target-sysroot ${finalAttrs.toolchain} \
      --target-dir ${outName} \
      --target-triple ${stdenv.targetPlatform.config} \
      --enable-fontconfig

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export TERM=dumb
  ''
  # ValueError: ZIP does not support timestamps before 1980
  + ''
    substituteInPlace src/flutter/build/zip.py \
      --replace-fail "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED)" "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED, strict_timestamps=False)"
  ''
  + ''
    ninja -C $out/out/${outName} -j$NIX_BUILD_CORES

    runHook postBuild
  '';

  # Tests are broken
  doCheck = false;
  checkPhase = ''
    runHook preCheck

    ln --symbolic $out/out src/out
    touch src/out/run_tests.log
    sh src/flutter/testing/run_tests.sh ${outName}
    rm src/out/run_tests.log

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    rm --recursive --force $out/out/${outName}/{obj,exe.unstripped,lib.unstripped,zip_archives}
    rm $out/out/${outName}/{args.gn,build.ninja,build.ninja.d,compile_commands.json,toolchain.ninja}
    find $out/out/${outName} -name '*_unittests' -delete
    find $out/out/${outName} -name '*_benchmarks' -delete
  ''
  + lib.optionalString (finalAttrs.finalPackage.doCheck) ''
    rm $out/out/${outName}/{display_list_rendertests,flutter_tester}
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    inherit
      dartSdkVersion
      isOptimized
      runtimeMode
      outName
      swiftshader
      ;
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
  };
})
