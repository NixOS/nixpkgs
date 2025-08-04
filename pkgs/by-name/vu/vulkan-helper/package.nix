{
  lib,
  rustPlatform,
  fetchFromGitHub,
  vulkan-loader,
  addDriverRunpath,
}:

rustPlatform.buildRustPackage {
  pname = "vulkan-helper";
  version = "0-unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "vulkan-helper-rs";
    rev = "04b290c92febcfd6293fcf4730ce3bba55cd9ce0";
    hash = "sha256-2pLHnTn0gJKz4gfrR6h85LHOaZPrhIGYzQeci4Dzz2E=";
  };

  cargoHash = "sha256-9Zc949redmYLCgDR9pabR4ZTtcvOjrXvviRdsb8AiBU=";

  nativeBuildInputs = [
    addDriverRunpath
  ];

  postFixup = ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/vulkan-helper
    addDriverRunpath $out/bin/vulkan-helper
  '';

  meta = {
    description = "Simple CLI app used to interface with basic Vulkan APIs";
    homepage = "https://github.com/imLinguin/vulkan-helper-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aidalgol ];
    platforms = lib.platforms.linux;
    mainProgram = "vulkan-helper";
  };
}
