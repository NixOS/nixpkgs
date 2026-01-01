{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  writeText,
  vulkan-headers,
  vulkan-utility-libraries,
  jq,
  libX11,
  libXrandr,
  libxcb,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-extension-layer";
<<<<<<< HEAD
  version = "1.4.335.0";
=======
  version = "1.4.328.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ExtensionLayer";
    rev = "vulkan-sdk-${version}";
<<<<<<< HEAD
    hash = "sha256-1Ax/0W882nJFO2hVqXamT89lFu5ncnrytnwDdUIihnk=";
=======
    hash = "sha256-J9l20abn7meSF0WnCh3cepYKQh10ezb0mAKzc0HAo1w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    jq
  ];

  buildInputs = [
    vulkan-headers
    vulkan-utility-libraries
    libX11
    libXrandr
    libxcb
    wayland
  ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    addToSearchPath XDG_DATA_DIRS @out@/share
  '';

  # Tests are not for gpu-less and headless environments
  cmakeFlags = [
    "-DBUILD_TESTS=false"
  ];

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Layers providing Vulkan features when native support is unavailable";
    homepage = "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Layers providing Vulkan features when native support is unavailable";
    homepage = "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/";
    platforms = platforms.linux;
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
