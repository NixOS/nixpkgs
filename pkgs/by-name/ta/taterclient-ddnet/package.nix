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
  gtest,
  glew,
  apple-sdk_11,
}:
let
  clientExecutable = "TaterClient-DDNet";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taterclient-ddnet";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "sjrc6";
    repo = "taterclient-ddnet";
    rev = "refs/tags/V${finalAttrs.version}";
    hash = "sha256-hGbeIhtAZcgaPCsDUmZqq8mLGi1yVvauha4wGMBbmBc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname src version;
    hash = "sha256-iykFbo1zSeG9r9cIr8CGjd9GtCGcQ6vH73xpEl8J3i8=";
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

  nativeCheckInputs = [ gtest ];
  checkInputs = [ gtest ];

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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace-fail /usr/ $out/
  '';

  cmakeFlags = [
    (lib.cmakeBool "AUTOUPDATE" false)
    (lib.cmakeBool "CLIENT" true)
    (lib.cmakeBool "SERVER" false)
    (lib.cmakeBool "TOOLS" false)
    (lib.cmakeFeature "CLIENT_EXECUTABLE" clientExecutable)
  ];

  doCheck = true;
  checkTarget = "run_tests";

  __darwinAllowLocalNetworking = true; # for tests

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
