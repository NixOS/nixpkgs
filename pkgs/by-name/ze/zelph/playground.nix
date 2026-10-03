{
  lib,
  buildEmscriptenPackage,
  writeTextDir,
  zelph,
  serve,
  xsel,

  # build-time
  cmake,
  janet,
  makeWrapper,
  meson,
  ninja,
  pkg-config,

  # run-time
  unordered_dense,
}:

let
  # `unordered_dense` is header-only, but its installed CMake config rejects
  # cross-compilation (CMAKE_SIZEOF_VOID_P 4 vs 8).
  #
  # Provide a config file that bypasses the arch check.
  unordered_dense_config = writeTextDir "unordered_denseConfig.cmake" ''
    set(unordered_dense_FOUND TRUE)
    set(unordered_dense_VERSION "${unordered_dense.version}")
    if(NOT TARGET unordered_dense::unordered_dense)
      add_library(unordered_dense::unordered_dense INTERFACE IMPORTED)
      set_target_properties(unordered_dense::unordered_dense PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${unordered_dense}/include"
      )
    endif()
  '';
in

buildEmscriptenPackage rec {
  pname = "zelph-playground";

  inherit (zelph)
    version
    src
    patches
    ;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    unordered_dense
  ];

  cmakeFlags = [
    (lib.cmakeBool "ZELPH_WASM" true)
    (lib.cmakeFeature "unordered_dense_DIR" "${unordered_dense_config}")
    # warning: flexible array members are a C99 feature [-Wc99-extensions]
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-c99-extensions")
  ];

  cmakeBuildType = "Release";

  preConfigure = ''
    cp -R ${janet.src} ./janet-src
    chmod -R u+w ./janet-src
    cmakeFlagsArray+=("-DJANET_SOURCE_DIR=$(pwd)/janet-src")
  '';

  configurePhase = ''
    runHook preConfigure

    mkdir -p .emscriptencache
    export EM_CACHE=$(pwd)/.emscriptencache

    emcmake cmake -S . -B . "''${cmakeFlags[@]}" "''${cmakeFlagsArray[@]}"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmake --build .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cmake --install . --prefix $out
    mkdir -p $out/share/zelph/playground
    cp bin/zelph.mjs bin/zelph.wasm $out/share/zelph/playground/
    cp ${src}/src/wasm/web/* $out/share/zelph/playground/

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    runHook postCheck
  '';

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/zelph-playground \
      --prefix PATH : ${lib.makeBinPath [ xsel ]} \
      --chdir $out/share/zelph/playground
  '';

  meta = zelph.meta // {
    description = "Semantic network system and reasoning engine (WebAssembly)";
    longDescription = ''
      The playground is the complete zelph reasoning engine — the same C++ core
      as the native binaries — compiled to WebAssembly.

      It runs entirely in your browser; nothing is sent to a server.
    '';
    mainProgram = "zelph-playground";
  };
}
