{
  lib,

  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinygltf";
  version = "3.1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zuFQob+N5Zk0/ZHZJA6nUAh45zaBR8g9dlrxwoOL26Q=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # unvendoring will break downstream applications
    # unless at least patch the CMake modules
    (lib.cmakeBool "TINYGLTF_INSTALL_VENDOR" true)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
