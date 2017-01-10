{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, wayland }:

let
  version = "1.0.26.0";
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "sdk-${version}";
    sha256 = "157m746hc76xrxd3qq0f44f5dy7pjbz8cx74ykqrlbc7rmpjpk58";
  };
in

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version src;

  prePatch = ''
    if [ "$(cat '${src}/spirv-tools_revision')" != '${spirv-tools.src.rev}' ] \
      || [ "$(cat '${src}/spirv-headers_revision')" != '${spirv-tools.headers.rev}' ] \
      || [ "$(cat '${src}/glslang_revision')" != '${glslang.src.rev}' ]
    then
      echo "Version mismatch, aborting!"
      false
    fi
  '';

  buildInputs = [ cmake pkgconfig git python3 python3Packages.lxml
                  glslang spirv-tools x11 libxcb wayland
                ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_WSI_WAYLAND_SUPPORT=ON" # XLIB/XCB supported by default
  ];

  patches = [ ./use-xdg-paths.patch ];

  outputs = [ "out" "dev" "demos" ];

  preConfigure = ''
    checkRev() {
      [ "$2" = $(cat "$1_revision") ] || (echo "ERROR: dependency $1 is revision $2 but should be revision" $(cat "$1_revision") && exit 1)
    }
    checkRev spirv-tools "${spirv-tools.src.rev}"
    checkRev spirv-headers "${spirv-tools.headers.rev}"
    checkRev glslang "${glslang.src.rev}"
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp -d loader/libvulkan.so* $out/lib
    cp demos/vulkaninfo $out/bin
    mkdir -p $out/lib $out/share/vulkan/explicit_layer.d
    cp -d layers/*.so $out/lib/
    cp -d layers/*.json $out/share/vulkan/explicit_layer.d/
    sed -i "s:\\./lib:$out/lib/lib:g" "$out/share/vulkan/"*/*.json
    mkdir -p $dev/include
    cp -rv ../include $dev/
    mkdir -p $demos/bin
    cp demos/smoketest demos/tri demos/cube demos/*.spv demos/*.ppm $demos/bin
   '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = "http://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
  };
}
