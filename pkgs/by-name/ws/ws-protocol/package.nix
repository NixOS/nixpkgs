{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  boost186,
  libwebsockets,
  nlohmann_json,
  websocketpp,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ws-protocol";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "ws-protocol";
    tag = "releases/cpp/v${finalAttrs.version}";
    hash = "sha256-JMCwxShOOv1PSrlKiPGtsCgKJVR+7ds9otKrlPHfIio=";
  };

  patches = [
    # Install cmake and pkg-config files to out
    (fetchpatch {
      url = "https://github.com/foxglove/ws-protocol/commit/2d44d39f1a7156b9e19cd9e283e891e1908042e1.patch";
      hash = "sha256-y61o6HHzPLesUm2aJB7RC0GuuUJyU9AQ2V3DHQntlkQ=";
    })
    # Missing libraries for Darwin
    (fetchpatch {
      url = "https://github.com/foxglove/ws-protocol/commit/336b3eaffd2369b255e3e66cfebaca3655e7c085.patch";
      hash = "sha256-Y4V8B6+rt+e27U7LH5/j46u7L1Je3tSdaeG1Ui53b6A=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost186
    libwebsockets
    websocketpp
    nlohmann_json
    openssl
    zlib
  ];

  # NOTE: Switch back once the patches are merged
  # sourceRoot = "${finalAttrs.src.name}/cpp/foxglove-websocket";

  postPatch = ''
    cd cpp/foxglove-websocket
  '';

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" true) ];

  meta = {
    description = "WebSocket protocol implementation";
    homepage = "https://github.com/foxglove/ws-protocol";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
