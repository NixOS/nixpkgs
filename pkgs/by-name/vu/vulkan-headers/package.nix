{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "vulkan-headers";
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    hash = "sha256-DIePLzDoImnaso0WYUv819wSDeA7Zy1I/tYAbsALXKg=";
=======
    hash = "sha256-Sg/zp6UhRC5wqBS3vdfs0sQL8cBgLiwvfG0oY0v9MWU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
    description = "Vulkan Header files and API registry";
    homepage = "https://www.lunarg.com";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
=======
  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage = "https://www.lunarg.com";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
