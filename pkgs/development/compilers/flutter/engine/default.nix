{
  callPackage,
  constants,
  dart,
  depot_tools,
  dos2unix,
  enginePatches,
  freetype,
  gn,
  gtk3,
  harfbuzz,
  lib,
  libepoxy,
  libjpeg,
  libpng,
  libwebp,
  libx11,
  libxxf86vm,
  llvmPackages,
  ninja,
  patches,
  pkg-config,
  python312,
  sqlite,
  stdenv,
  symlinkJoin,
  version,
  zlib,
  runtimeMode ? "release",
}:

let
  python3 = python312;

  llvm = symlinkJoin {
    name = "llvm";
    paths = [
      llvmPackages.clang
      llvmPackages.llvm
    ];
  };

  outputAttrs = {
    flutter-gtk =
      lib.replaceStrings [ "-" "/" ] [ "_M_" "_S_" ]
        "${constants.hostConstants.alt-platform}-${runtimeMode}/${constants.hostConstants.alt-platform}-flutter-gtk";
    flutter-glfw =
      lib.replaceStrings [ "-" "/" ] [ "_M_" "_S_" ]
        "${constants.hostConstants.alt-platform}-${runtimeMode}/${constants.hostConstants.alt-platform}-flutter-glfw";
    font-subset =
      lib.replaceStrings [ "-" "/" ] [ "_M_" "_S_" ]
        "${constants.hostConstants.alt-platform}/font-subset";
    artifacts =
      lib.replaceStrings [ "-" "/" ] [ "_M_" "_S_" ]
        "${constants.hostConstants.alt-platform}/artifacts";
    flutter_patched_sdk = "flutter_patched_sdk";
  };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "flutter-engine-linux-${runtimeMode}";
  inherit version;

  src = callPackage ./source.nix { };

  sourceRoot = "${finalAttrs.src.name}/engine/src";

  prePatch = ''
    pushd ../..
    chmod --recursive +w .
  '';

  patches = patches ++ enginePatches;

  postPatch = ''
    popd
    dos2unix flutter/third_party/vulkan_memory_allocator/include/vk_mem_alloc.h
    patchShebangs ../../bin/internal/content_aware_hash.sh
    mkdir --parents flutter/third_party/dart/tools/sdks/dart-sdk/ flutter/prebuilts/${constants.hostConstants.alt-platform}/dart-sdk
    ln --symbolic ${dart}/bin flutter/third_party/dart/tools/sdks/dart-sdk/bin
    ln --symbolic ${dart}/bin flutter/prebuilts/${constants.hostConstants.alt-platform}/dart-sdk/bin
    echo "${dart.version}" > flutter/third_party/dart/sdk/version
    mkdir --parents flutter/third_party/gn/
    ln --symbolic ${lib.getExe gn} flutter/third_party/gn/gn
    mkdir --parents flutter/third_party/swiftshader/third_party
    ln --symbolic ${llvmPackages.llvm.monorepoSrc} flutter/third_party/swiftshader/third_party/llvm-project
    mkdir --parents flutter/buildtools/${constants.hostConstants.alt-platform}
    ln --symbolic ${llvm} flutter/buildtools/${constants.hostConstants.alt-platform}/clang
  ''
  # https://github.com/dart-lang/sdk/issues/52295
  + ''
    mkdir --parents flutter/third_party/dart/.git/logs
    touch flutter/third_party/dart/.git/logs/HEAD
  ''
  # DEPS hooks
  + ''
    python3 flutter/third_party/dart/tools/generate_package_config.py
    python3 flutter/third_party/dart/tools/generate_sdk_version_file.py
    python3 flutter/tools/pub_get_offline.py
  ''
  # reusable system library settings
  + ''
    local use_system="
      freetype2
      harfbuzz
      libjpeg-turbo
      libpng
      libwebp
      sqlite
      zlib
      "
    for _lib in $use_system; do
      echo "Removing buildscripts for system provided $_lib"
      find . -type f -path "*third_party/$_lib/*" \
        \! -path "*third_party/$_lib/chromium/*" \
        \! -path "*third_party/$_lib/google/*" \
        \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
        -delete
    done
    echo "Replacing gn files"
    python3 build/linux/unbundle/replace_gn_files.py --system-libraries $use_system
  ''
  # ValueError: ZIP does not support timestamps before 1980
  + ''
    substituteInPlace flutter/build/zip.py \
      --replace-fail "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED)" "zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED, strict_timestamps=False)"
  ''
  + ''
    sed --in-place '5i #include <cstring>' flutter/display_list/dl_storage.cc
    sed --in-place '5i #include <cstring>' flutter/display_list/dl_vertices.cc
    sed --in-place '5i #include <cstring>' flutter/display_list/effects/color_filters/dl_matrix_color_filter.h
    sed --in-place '5i #include <cstring>' flutter/display_list/geometry/dl_region.cc
    sed --in-place '5i #include <cstring>' flutter/display_list/effects/dl_color_source.cc
    sed --in-place '5i #include <cstring>' flutter/display_list/dl_builder.cc
    sed --in-place '5i #include <cstring>' flutter/display_list/display_list.cc
    sed --in-place '5i #include <cstring>' flutter/vulkan/vulkan_application.cc
    sed --in-place '5i #include <cstring>' flutter/runtime/dart_vm.cc
    sed --in-place '5i #include <cstring>' flutter/runtime/dart_isolate.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/android/android_surface_gl_skia.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/glfw/platform_handler.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_accessibility_channel.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_text_input_handler.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_application.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_event_channel.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_keyboard_channel.cc
    sed --in-place '5i #include <cstring>' flutter/impeller/renderer/backend/vulkan/debug_report_vk.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_text_input_channel.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_settings_portal.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_gnome_settings.cc
    sed --in-place '5i #include <cstring>' flutter/impeller/toolkit/glvk/trampoline.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/android/android_context_dynamic_impeller.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/fuchsia/dart_runner/builtin_libraries.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/fuchsia/flutter/text_delegate.cc
    sed --in-place '5i #include <cstring>' flutter/third_party/accessibility/ax/ax_enum_util.cc
    sed --in-place '5i #include <cstring>' flutter/examples/vulkan_glfw/src/main.cc
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/public/flutter_linux/fl_method_channel.h
    sed --in-place '5i #include <cstring>' flutter/shell/platform/linux/fl_accessible_text_field.cc
    substituteInPlace flutter/shell/platform/linux/fl_view_accessible.cc \
      --replace-fail "// Workaround missing C code compatibility in ATK header." "#include <glib.h>"
  '';

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ pyyaml ]))
    dart
    depot_tools
    dos2unix
    ninja
    pkg-config
  ];

  buildInputs = [
    freetype
    gtk3
    harfbuzz
    libepoxy
    libjpeg
    libpng
    libwebp
    libx11
    libxxf86vm
    sqlite
    zlib
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-O2"
        "-Wno-error"
        "-Wno-unused-command-line-argument"
        "-Wno-absolute-value"
        "-Wno-implicit-float-conversion"
        "-Wno-error=unused-command-line-argument"
        "-D_GLIBCXX_DEBUG=0"
      ]
      ++ (lib.optionals stdenv.hostPlatform.isLinux [ "-U_FORTIFY_SOURCE" ])
    );
    TERM = "dumb";
  };

  configurePhase =
    let
      gnFlags = lib.concatStringsSep " " (
        [
          "--no-goma"
          "--no-dart-version-git-info"
          "--linux"
          "--linux-cpu=${constants.hostConstants.alt-arch}"
          "--runtime-mode=${runtimeMode}"
          "--no-rbe"
          "--prebuilt-dart-sdk"
          "--build-glfw-shell"
          "--build-engine-artifacts"
          "--no-enable-unittests"
          "--enable-fontconfig"
          ''--gn-args="use_default_linux_sysroot=false"''
        ]
        ++ (lib.optionals (runtimeMode == "release") [ "--no-backtrace" ])
        ++ (
          if (runtimeMode == "debug") then
            [
              "--unoptimized"
              "--no-stripped"
            ]
          else
            [ "--no-lto" ]
        )
      );
    in
    ''
      runHook preConfigure

      python3 flutter/tools/gn ${gnFlags} --target-dir="${constants.hostConstants.alt-platform}-${runtimeMode}"

      runHook postConfigure
    '';

  buildPhase = ''
    runHook preBuild

    ninja -C out/${constants.hostConstants.alt-platform}-${runtimeMode} -j $NIX_BUILD_CORES

    runHook postBuild
  '';

  outputs = [ "out" ] ++ builtins.attrValues outputAttrs;

  installPhase = ''
    runHook preInstall

    pushd out/${constants.hostConstants.alt-platform}-${runtimeMode}
  ''
  # flutter-gtk
  + ''
    install -D --mode=0644 libflutter_linux_gtk.so --target-directory=''$${outputAttrs.flutter-gtk}
    install -D --mode=0755 gen_snapshot --target-directory=''$${outputAttrs.flutter-gtk}
    cp --recursive flutter_linux ''$${outputAttrs.flutter-gtk}/flutter_linux
  ''
  # flutter-glfw
  + ''
    install -D --mode=0644 flutter_export.h --target-directory=''$${outputAttrs.flutter-glfw}
    install -D --mode=0644 flutter_glfw.h --target-directory=''$${outputAttrs.flutter-glfw}
    install -D --mode=0644 flutter_messenger.h --target-directory=''$${outputAttrs.flutter-glfw}
    install -D --mode=0644 flutter_plugin_registrar.h --target-directory=''$${outputAttrs.flutter-glfw}
    install -D --mode=0755 gen_snapshot --target-directory=''$${outputAttrs.flutter-glfw}
    install -D --mode=0644 libflutter_linux_glfw.so --target-directory=''$${outputAttrs.flutter-glfw}
  ''
  # font-subset
  + ''
    install -D --mode=0644 font-subset --target-directory=''$${outputAttrs.font-subset}
    install -D --mode=0644 gen/const_finder.dart.snapshot --target-directory=''$${outputAttrs.font-subset}
  ''
  # flutter_patched_sdk
  + ''
    install -D --mode=0644 gen/flutter/build/archives/LICENSE.flutter_patched_sdk.md ''$${outputAttrs.flutter_patched_sdk}/LICENSE.flutter_patched_sdk.md
    install -D --mode=0644 flutter_patched_sdk/platform_strong.dill --target-directory=''$${outputAttrs.flutter_patched_sdk}/flutter_patched_sdk/
    install -D --mode=0644 flutter_patched_sdk/vm_outline_strong.dill --target-directory=''$${outputAttrs.flutter_patched_sdk}/flutter_patched_sdk/
  ''
  # artifacts
  + ''
    install -D --mode=0644 gen/flutter/lib/snapshot/vm_isolate_snapshot.bin --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 gen/flutter/lib/snapshot/isolate_snapshot.bin --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 icudtl.dat --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 flutter_tester --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 gen/frontend_server_aot.dart.snapshot --target-directory=''$${outputAttrs.artifacts}/frontend_server.dart.snapshot
    install -D --mode=0644 gen/flutter/build/archives/LICENSE.artifacts.md --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 gen/flutter/lib/snapshot/vm_isolate_snapshot.bin --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 libtessellator.so --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 libpath_ops.so --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 gen/flutter/lib/snapshot/isolate_snapshot.bin --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0644 libimpeller.so --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0755 gen_snapshot --target-directory=''$${outputAttrs.artifacts}
    install -D --mode=0755 impellerc --target-directory=''$${outputAttrs.artifacts}
    cp --recursive shader_lib ''$${outputAttrs.artifacts}/shader_lib
  ''
  # others
  + ''
    install -D --mode=0644 libflutter_engine.so --target-directory=$out
    install -D --mode=0755 analyze_snapshot --target-directory=$out
    popd

    runHook postInstall
  '';

  dontStrip = (runtimeMode != "release");

  meta = {
    broken = stdenv.hostPlatform.isDarwin || (lib.versionOlder version "3.41");
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
