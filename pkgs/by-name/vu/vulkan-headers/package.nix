{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-headers";
  version = "1.4.335.0";

  # Adding `ninja` here to enable Ninja backend. Otherwise on gcc-14 or
  # later the build fails as:
  #   modules are not supported by this generator: Unix Makefiles
  nativeBuildInputs = [
    cmake
    ninja
  ];

  # TODO: investigate why <algorithm> isn't found
  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "-DVULKAN_HEADERS_ENABLE_MODULE=OFF" ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-DIePLzDoImnaso0WYUv819wSDeA7Zy1I/tYAbsALXKg=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Vulkan Header files and API registry";
    homepage = "https://www.lunarg.com";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
  };
})
