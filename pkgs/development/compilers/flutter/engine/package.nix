{
  lib,
  callPackage,
  writeText,
  symlinkJoin,
  targetPlatform,
  buildPlatform,
  darwin,
  clang,
  llvm,
  tools ? callPackage ./tools.nix { inherit buildPlatform; },
  stdenv,
  stdenvNoCC,
  dart,
  fetchgit,
  runCommand,
  llvmPackages,
  llvmPackages_15,
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
  python39,
  git,
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

  constants = callPackage ./constants.nix { platform = targetPlatform; };

  python3 = if lib.versionAtLeast flutterVersion "3.20" then python312 else python39;

  src = callPackage ./source.nix {
    inherit
      tools
      flutterVersion
      version
      hashes
      url
      targetPlatform
      buildPlatform
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
    paths = with llvmPackages; [
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
        lib.optionals (stdenv.isLinux) [
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
        ++ lib.optionals (stdenv.isDarwin) [
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
  ] ++ lib.optional (!isOptimized) "-U_FORTIFY_SOURCE";

  nativeCheckInputs = lib.optionals stdenv.isLinux [
    xorg.xorgserver
    openbox
  ];

  nativeBuildInputs =
    [
      python3
      (tools.vpython python3)
      git
      pkg-config
      ninja
      dart
    ]
    ++ lib.optionals (stdenv.isLinux) [ patchelf ]
    ++ lib.optionals (stdenv.isDarwin) [
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
  ] ++ lib.optional (lib.versionAtLeast flutterVersion "3.21") "flutter/third_party/skia";

  postUnpack = ''
    pushd ${src.name}

    cp ${./pkg-config.py} src/build/config/linux/pkg-config.py

    cp -pr --reflink=auto $swiftshader src/flutter/third_party/swiftshader
    chmod -R u+w -- src/flutter/third_party/swiftshader

    ln -s ${llvmPackages_15.llvm.monorepoSrc} src/flutter/third_party/swiftshader/third_party/llvm-project

    mkdir -p src/flutter/buildtools/${constants.alt-platform}
    ln -s ${llvm} src/flutter/buildtools/${constants.alt-platform}/clang

    mkdir -p src/buildtools/${constants.alt-platform}
    ln -s ${llvm} src/buildtools/${constants.alt-platform}/clang

    mkdir -p src/${dartPath}/tools/sdks
    ln -s ${dart} src/${dartPath}/tools/sdks/dart-sdk

    ${lib.optionalString (stdenv.isLinux) ''
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
    popd
  '';

  configureFlags =
    [
      "--no-prebuilt-dart-sdk"
      "--embedder-for-target"
      "--no-goma"
    ]
    ++ lib.optionals (targetPlatform.isx86_64 == false) [
      "--linux"
      "--linux-cpu ${constants.alt-arch}"
    ]
    ++ lib.optional (!isOptimized) "--unoptimized"
    ++ lib.optional (runtimeMode == "debug") "--no-stripped"
    ++ lib.optional finalAttrs.doCheck "--enable-unittests"
    ++ lib.optional (!finalAttrs.doCheck) "--no-enable-unittests";

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
        --target-dir $outName \
        --target-triple ${targetPlatform.config} \
        --enable-fontconfig

      runHook postConfigure
    '';

  buildPhase = ''
    runHook preBuild

    export TERM=dumb

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

    rm -rf $out/out/$outName/{obj,gen,exe.unstripped,lib.unstripped,zip_archives}
    rm $out/out/$outName/{args.gn,build.ninja,build.ninja.d,compile_commands.json,toolchain.ninja}
    find $out/out/$outName -name '*_unittests' -delete
    find $out/out/$outName -name '*_benchmarks' -delete
  '' + lib.optionalString (finalAttrs.doCheck) ''
    rm $out/out/$outName/{display_list_rendertests,flutter_tester}
  '' + ''
    runHook postInstall
  '';

  passthru = {
    dart = callPackage ./dart.nix { engine = finalAttrs.finalPackage; };
  };

  meta = with lib; {
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
  } // lib.optionalAttrs (lib.versionOlder flutterVersion "3.22") { hydraPlatforms = [ ]; };
})
