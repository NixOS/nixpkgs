{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  stdenv,
  llvmPackages_15,
  overrideLibcxx,
  cmake,
  xorg,
  libxkbcommon,
  alsa-lib,
  libpulseaudio,
  makeWrapper,
  nix-update-script,
}:
let
  # upstream ci uses clang 15 for macos builds. newest version fails to build
  # wasm6, a dependency of the native runtime
  superStdenv = if stdenv.cc.isClang then overrideLibcxx llvmPackages_15.stdenv else stdenv;
  version = "2.7.1";
  src = fetchFromGitHub {
    owner = "aduros";
    repo = "wasm4";
    tag = "v${version}";
    hash = "sha256-QmSqQh+8w8pxoQcgHrsTfv/lIb5Xh7LkATnSMDUwjKo=";
    # native runtime has submodule-vendored dependencies
    fetchSubmodules = true;
  };
  webDevtools = buildNpmPackage (finalAttrs: {
    pname = "web-devtools";
    inherit version;

    inherit src;
    sourceRoot = "${src.name}/devtools/web";

    npmDepsHash = "sha256-XPSnhQLdzIKY2qCiIfTIXQ8rOm7Tg5nPW7XEE1gmxRo=";
    # dontNpmBuild = true;
  });
  webRuntime = buildNpmPackage (finalAttrs: {
    pname = "wasm4-runtime";
    inherit version;

    inherit src;
    sourceRoot = "${src.name}/runtimes/web";

    patches = [ ./0001-vendor-web-devtools-elsewhere.patch ];
    preBuildPhases = [ "provideWebDevtoolsPhase" ];
    provideWebDevtoolsPhase = ''
      mkdir -p node_modules/@wasm4
      ln -s ${webDevtools}/lib/node_modules/@wasm4/web-devtools node_modules/@wasm4/web-devtools
    '';
    installPhase = ''
      cp -r dist $out
    '';

    npmDepsHash = "sha256-LHyfNk0bCsWOB3uAIDqxyN7mpQJ6IsM5Oqx8V3/iNzc=";
  });
  nativeRuntime = superStdenv.mkDerivation (finalAttrs: {
    pname = "wasm4-runtime-native";
    inherit version;

    inherit src;
    sourceRoot = "${finalAttrs.src.name}/runtimes/native";

    cmakeFlags = [ "-DWASM_BACKEND=wasm3" ];
    installPhase = ''
      # this fails... but it does so on upstream ci too, and it just ignores it
      # and uses the partial install.
      cmake --install . --prefix $out --config Release --strip || true
    '';
    preFixupPhases = lib.optionals superStdenv.hostPlatform.isLinux [ "wrapRuntimePhase" ];
    wrapRuntimePhase = ''
      wrapProgram $out/bin/wasm4 --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio ]}
    '';

    nativeBuildInputs = [
      cmake
      makeWrapper
    ];
    buildInputs = lib.optionals superStdenv.hostPlatform.isLinux [
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXi
      xorg.libXext
      libxkbcommon
      alsa-lib
      libpulseaudio
    ];
  });
in
buildNpmPackage (finalAttrs: {
  pname = "wasm4";
  inherit version;

  inherit src;
  sourceRoot = "${src.name}/cli";

  preBuildPhases =
    [ "provideWebRuntimePhase" ]
    ++ lib.optionals superStdenv.hostPlatform.isLinux [ "provideNativeLinuxRuntimePhase" ]
    ++ lib.optionals superStdenv.hostPlatform.isDarwin [ "provideNativeDarwinRuntimePhase" ];
  provideWebRuntimePhase = ''
    rm assets/runtime
    cp -r ${webRuntime} assets/runtime
  '';
  provideNativeLinuxRuntimePhase = ''
    mkdir -p assets/natives
    cp ${nativeRuntime}/bin/wasm4 assets/natives/wasm4-linux
  '';
  provideNativeDarwinRuntimePhase = ''
    mkdir -p assets/natives
    cp ${nativeRuntime}/bin/wasm4 assets/natives/wasm4-mac
  '';

  npmDepsHash = "sha256-p+sh1BHHmOY9mvUDOA/9KgoWTXwBfrlK2tqhXLQSeXk=";
  dontNpmBuild = true;

  meta = {
    description = "Build retro games using WebAssembly for a fantasy console";
    homepage = "https://wasm4.org";
    downloadPage = "https://wasm4.org/docs/getting-started/setup";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ MacaylaMarvelous81 ];
    mainProgram = "w4";
    platforms = lib.platforms.all;
  };
})
