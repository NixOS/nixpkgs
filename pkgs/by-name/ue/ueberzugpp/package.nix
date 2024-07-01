{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, zeromq
, cppzmq
, tbb_2021_11
, spdlog
, libsodium
, fmt
, vips
, nlohmann_json
, libsixel
, microsoft-gsl
, chafa
, cli11
, libexif
, range-v3
, enableOpencv ? stdenv.isLinux
, opencv
, enableWayland ? stdenv.isLinux
, extra-cmake-modules
, wayland
, wayland-protocols
, enableX11 ? stdenv.isLinux
, xorg
}:

stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    rev = "v${version}";
    hash = "sha256-qo9Rwnx6Oh8DRcCBUMS3JVdNyx1iZSB2Z1qfptUoPFQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zeromq
    cppzmq
    tbb_2021_11
    spdlog
    libsodium
    fmt
    vips
    nlohmann_json
    libsixel
    microsoft-gsl
    chafa
    cli11
    libexif
    range-v3
  ] ++ lib.optionals enableOpencv [
    opencv
  ] ++ lib.optionals enableWayland [
    extra-cmake-modules
    wayland
    wayland-protocols
  ] ++ lib.optionals enableX11 [
    xorg.libX11
    xorg.xcbutilimage
  ];

  cmakeFlags = lib.optionals (!enableOpencv) [
    "-DENABLE_OPENCV=OFF"
  ] ++ lib.optionals enableWayland [
    "-DENABLE_WAYLAND=ON"
  ] ++ lib.optionals (!enableX11) [
    "-DENABLE_X11=OFF"
  ];

  # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.14 or newer
  preBuild = lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0") ''
    export MACOSX_DEPLOYMENT_TARGET=10.14
  '';

  meta = with lib; {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana wegank ];
    platforms = platforms.unix;
  };
}
