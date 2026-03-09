{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  glfw,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vk-bootstrap";
  version = "1.4.335";

  src = fetchFromGitHub {
    owner = "charles-lunarg";
    repo = "vk-bootstrap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WFROoVAOl4HBNb/a8rx522Zz2LP4m2Zk03jckWxv7w0=";
  };

  patches = [
    ./0001-disable-fetch-content.patch
    ./0002-fix-install-tests.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
  ];

  checkInputs = [
    glfw
    catch2_3
  ];

  doCheck = true;

  cmakeFlags = [
    "-DVK_BOOTSTRAP_INSTALL=1"
  ];

  meta = {
    description = "Vulkan Bootstrapping Library";
    license = lib.licenses.mit;
    homepage = "https://github.com/charles-lunarg/vk-bootstrap";
    platforms = lib.platforms.all;
  };
})
