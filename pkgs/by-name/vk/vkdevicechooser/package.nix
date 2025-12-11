{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  meson,
  vulkan-headers,
  vulkan-utility-libraries,
  ninja,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "vkdevicechooser";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jiriks74";
    repo = "vkdevicechooser";
    rev = version;
    hash = "sha256-j4hefarOQ3q0sKkB2g/dO2/4bSYzt4oxmCna0nMAjFk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    jq
  ];

  buildInputs = [
    vulkan-headers
    vulkan-utility-libraries
  ];

  # Help vulkan-loader find the layer
  setupHook = writeText "setup-hook" ''
    addToSearchPath XDG_DATA_DIRS @out@/share
  '';

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = {
    description = "Vulkan layer to force a specific device to be used";
    homepage = "https://github.com/aejsmith/vkdevicechooser";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmike ];
  };
}
