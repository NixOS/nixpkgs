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
  apple-sdk_11,
}:
let
  clientExecutable = "TaterClient-DDNet";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taterclient-ddnet";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "sjrc6";
    repo = "taterclient-ddnet";
    rev = "refs/tags/V${finalAttrs.version}";
    hash = "sha256-s+GIY29WYbVETtJSLBfP87pakRfxgGcw3Dk3p6HHoYA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname src version;
    hash = "sha256-u+IhlJYVEYeWnmFzRmcVqJfM3zBy70k9yp0AjRTovwg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [ gtest ];

  buildInputs =
    [
      curl
      libnotify
      pcre
      python3
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
    ];

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace-fail /usr/ $out/
  '';

  cmakeFlags = [
    "-DAUTOUPDATE=OFF"
    "-DCLIENT=ON"
    "-DSERVER=OFF"
    "-DTOOLS=OFF"
    "-DCLIENT_EXECUTABLE=${clientExecutable}"
  ];

  # Tests loop forever on Darwin for some reason
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkTarget = "run_tests";

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
