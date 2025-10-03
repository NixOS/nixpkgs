{
  lib,
  stdenv,
  cscope,
  fetchFromGitHub,
  git,
  installShellFiles,
  libevent,
  libopus,
  libsodium,
  libtoxcore,
  libvpx,
  msgpack,
  pkg-config,
  python3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuntox";
  version = "0.0.10.1";

  src = fetchFromGitHub {
    owner = "gjedeer";
    repo = "tuntox";
    tag = finalAttrs.version;
    hash = "sha256-LsFmTRojs0nUCd8ER+v1S7XlmSGa2lV4ugqFsU6Td/8=";
  };

  nativeBuildInputs = [
    cscope
    git
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libopus
    libtoxcore
    libsodium
    libevent
    libvpx
    msgpack
    python3
  ];

  pythonBuildInputs = with python3Packages; [
    jinja2
    requests
  ];

  postPatch = ''
    substituteInPlace gitversion.h --replace-fail '7d45afdf7d00a95a8c3687175e2b1669fa1f7745' '4eda1442c458506158257341ab6d3fd4543288cc'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace Makefile --replace-fail ' -static ' ' '
    substituteInPlace Makefile --replace-fail 'CC=gcc' ' '
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.mac --replace-fail '.git/HEAD .git/index' ' '
    substituteInPlace Makefile.mac --replace-fail '/usr/local/lib/libtoxcore.a' '${libtoxcore}/lib/libtoxcore.a'
    substituteInPlace Makefile.mac --replace-fail '/usr/local/lib/libsodium.a' '${libsodium}/lib/libsodium.dylib'
    substituteInPlace Makefile.mac --replace-fail 'CC=gcc' ' '
  '';

  buildPhase = ''
    runHook preBuild
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    make
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    make -f Makefile.mac tuntox
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin tuntox

    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Tunnel TCP connections over the Tox protocol";
    mainProgram = "tuntox";
    homepage = "https://github.com/gjedeer/tuntox";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
    platforms = lib.platforms.unix;
  };
})
