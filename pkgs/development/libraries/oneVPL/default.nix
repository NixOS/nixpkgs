{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libdrm
, libffi
, libpciaccess
, libva
, libX11
, libXau
, libXdmcp
, wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "onevpl";
  version = "2023.3.1";

  outputs = [ "out" "bin" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneVPL";
    rev = "v${version}";
    sha256 = "sha256-kFW5n3uGTS+7ATKAuVff5fK3LwEKdCQVgGElgypmrG4=";
  };

  cmakeFlags = [
    "-DVPL_INSTALL_PKGCONFIGDIR=${placeholder "dev"}"
    "-DVPL_INSTALL_ENVDIR=${placeholder "dev"}"
    "-DBUILD_TESTS=OFF"
    "-DENABLE_DRI3=ON"
    "-DENABLE_DRM=ON"
    "-DENABLE_VA=ON"
    "-DENABLE_WAYLAND=ON"
    "-DENABLE_X11=ON"
    "-DINSTALL_EXAMPLE_CODE=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libdrm
    libffi
    libpciaccess
    libva
    libX11
    libXau
    libXdmcp
    wayland
    wayland-protocols
  ];

  meta = {
    description = "oneAPI Video Processing Library, dispatcher, tools, and examples";
    homepage = "https://github.com/oneapi-src/oneVPL";
    changelog = "https://github.com/oneapi-src/oneVPL/releases/tag/v${version}";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.evanrichter ];
  };
}
