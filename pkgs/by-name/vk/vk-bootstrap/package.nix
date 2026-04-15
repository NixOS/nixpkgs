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
  version = "1.4.341";

  src = fetchFromGitHub {
    owner = "charles-lunarg";
    repo = "vk-bootstrap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JbgcjhCehCWzLDY/6PP3NeSY09IRuup8ym5n0c6rNEs=";
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
