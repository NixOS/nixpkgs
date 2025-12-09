{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  glfw,
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "vk-bootstrap";
  version = "1.4.334";

  src = fetchFromGitHub {
    owner = "charles-lunarg";
    repo = "vk-bootstrap";
    tag = "v${version}";
    hash = "sha256-tUh6FTGdIye250Xk6iwsTGEGFh7PYIQPJgmAGxID+1U=";
  };

  postPatch = ''
    # Upstream uses cmake FetchContent to resolve glfw and catch2
    # needed for examples and tests
    sed -i 's=add_subdirectory(ext)==g' CMakeLists.txt
    sed -i 's=Catch2==g' tests/CMakeLists.txt
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
    glfw
    catch2
  ];

  cmakeFlags = [
    "-DVK_BOOTSTRAP_VULKAN_HEADER_DIR=${vulkan-headers}/include"
  ];

  meta = {
    description = "Vulkan Bootstrapping Library";
    license = lib.licenses.mit;
    homepage = "https://github.com/charles-lunarg/vk-bootstrap";
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = lib.platforms.all;
  };
}
