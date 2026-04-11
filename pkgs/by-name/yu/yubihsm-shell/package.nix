{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  libusb1,
  libedit,
  makeWrapper,
  curl,
  gengetopt,
  patchelf,
  pkg-config,
  pcsclite,
  help2man,
  libiconv,

  # for installCheckPhase
  versionCheckHook,
  jq,
  yubihsm-connector,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yubihsm-shell";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-shell";
    rev = finalAttrs.version;
    hash = "sha256-qWz9fWhwNObvHERvJTWSN3DQsaPNnPEp4SEdYQvFAlY=";
  };

  postPatch = ''
    # ld: unknown option: -z
    substituteInPlace CMakeLists.txt cmake/SecurityFlags.cmake \
      --replace-fail "AppleClang" "Clang"
  '';

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      patchelf
    ]
    ++ [
      pkg-config
      cmake
      help2man
      gengetopt
      makeWrapper
    ];

  buildInputs = [
    libusb1
    libedit
    curl
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  # libyubihsm.so performs a dlopen() to connectors in $out/lib,
  # this will solve search path issues for both the command line tools
  # and the PKCS#11 library without patching
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --force-rpath --add-rpath "$out/lib" "$out/lib/libyubihsm.so"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -add_rpath "$out/lib" "$out/lib/libyubihsm.dylib"
    '';

  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    yubihsm-connector
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    # yubihsm-shell should be able to connect to yubihsm-connector over http if postFixup worked
    # note that checkPhase is more extensive and seems to require a YubiHSM plugged in,
    # so we expect a failure here, but it should at least try to connect
    yubihsm-connector -d </dev/null 1>&2 2>connector.log &
    yubihsm_pid=$!
    idx=0
    while ! grep takeoff connector.log >/dev/null && [ $idx -lt 10 ]; do
      idx=$((idx+1))
      echo "Waiting for yubihsm-connector startup (try: $idx)" >&2
      sleep 1
    done
    $out/bin/yubihsm-shell -Pv1 </dev/null || true
    kill -INT "$yubihsm_pid" && { wait "$yubihsm_pid" || true; }
    cat connector.log >&2
    grep -E 'GET.+/connector/status' connector.log >/dev/null

    runHook postInstallCheck
  '';

  meta = {
    mainProgram = "yubihsm-shell";
    description = "Thin wrapper around libyubihsm providing both an interactive and command-line interface to a YubiHSM";
    homepage = "https://github.com/Yubico/yubihsm-shell";
    maintainers = with lib.maintainers; [
      matthewcroughan
      numinit
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
