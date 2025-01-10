{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = "1.3.296.0";

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
    rev = "vulkan-sdk-${version}";
    hash = "sha256-u/40rOQyYbQza0aYbechLdKhYM1DgoMKkxauW2zZ/w0=";
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage = "https://www.lunarg.com";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
