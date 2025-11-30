{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  curl,
  freetype,
  libGLU,
  libnotify,
  libogg,
  libX11,
  opusfile,
  pcre,
  python3,
  SDL2,
  sqlite,
  wavpack,
  ffmpeg,
  x264,
  vulkan-headers,
  vulkan-loader,
  glslang,
  spirv-tools,
  glew,
}:
let
  clientExecutable = "TaterClient-DDNet";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taterclient-ddnet";
  version = "10.6.0";

  src = fetchFromGitHub {
    owner = "sjrc6";
    repo = "taterclient-ddnet";
    tag = "V${finalAttrs.version}";
    hash = "sha256-Z5W+IBiNhEXyBVk6w2YzotBlHam1fELmr3ojJ0q4Ge8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-VKGc4LQjt2FHbELLBKtV8rKpxjGBrzlA3m9BSdZ/6Z0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
    glslang # for glslangValidator
    python3
  ];

  buildInputs = [
    curl
    libnotify
    pcre
    sqlite
    freetype
    libGLU
    libogg
    opusfile
    SDL2
    wavpack
    ffmpeg
    x264
    vulkan-loader
    vulkan-headers
    glslang
    spirv-tools
    glew
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace-fail "/usr/" "$out/"

    # Substitute date and time CMake macros. It avoids to the client being banned on some Teeworlds servers.
    substituteInPlace src/engine/client/client.cpp \
      --replace-fail "__DATE__" "\"$(date +'%b %e %Y')\"" \
      --replace-fail "__TIME__" "\"$(date +'%H:%M:%S')\""
  '';

  cmakeFlags = [
    (lib.cmakeBool "AUTOUPDATE" false)
    (lib.cmakeBool "CLIENT" true)
    (lib.cmakeBool "SERVER" false)
    (lib.cmakeBool "TOOLS" false)
    (lib.cmakeBool "DISCORD" false)
    (lib.cmakeFeature "CLIENT_EXECUTABLE" clientExecutable)
  ];

  # Since we are not building the server executable, the `run_tests` Makefile target
  # will not be generated.
  #
  # See https://github.com/sjrc6/TaterClient-ddnet/blob/V10.6.0/CMakeLists.txt#L3179
  doCheck = false;

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Upstream links against <prefix>/lib while it installs this library in <prefix>/lib/ddnet
    install_name_tool -change "$out/lib/libsteam_api.dylib" "$out/lib/ddnet/libsteam_api.dylib" "$out/bin/${clientExecutable}"
  '';

  postInstall = ''
    # Desktop application conflicts with the ddnet package
    mv "$out/share/applications/ddnet.desktop" "$out/share/applications/taterclient-ddnet.desktop"

    substituteInPlace $out/share/applications/taterclient-ddnet.desktop \
      --replace-fail "Exec=DDNet" "Exec=${clientExecutable}" \
      --replace-fail "Name=DDNet" "Name=TaterClient (DDNet)" \
      --replace-fail "Comment=Launch DDNet" "Comment=Launch ${clientExecutable}"
  '';

  meta = {
    description = "Modification of DDNet teeworlds client";
    homepage = "https://github.com/sjrc6/taterclient-ddnet";
    changelog = "https://github.com/sjrc6/taterclient-ddnet/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      melon
      theobori
    ];
    mainProgram = clientExecutable;
  };
})
