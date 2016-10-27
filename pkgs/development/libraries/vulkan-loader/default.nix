{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, wayland, jq }:

assert stdenv.system == "x86_64-linux";
with stdenv.lib;
let
  version = "1.0.26.0";
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "sdk-${version}";
    sha256 = "157m746hc76xrxd3qq0f44f5dy7pjbz8cx74ykqrlbc7rmpjpk58";
  };
  driverLink = "/run/opengl-driver" + optionalString stdenv.isi686 "-32";
in

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version src;

  prePatch = ''
    checkRev() {
      [ "$2" = $(cat "$1_revision") ] || (echo "ERROR: dependency $1 is revision $2 but should be revision" $(cat "$1_revision") && exit 1)
    }
    checkRev spirv-tools "${spirv-tools.src.rev}"
    checkRev spirv-headers "${spirv-tools.headers.rev}"
    checkRev glslang "${glslang.src.rev}"
  '';

  postPatch = ''
    substituteInPlace loader/vk_loader_platform.h --replace '"/usr/"' '"${driverLink}/"'
  '';

  buildInputs = [ cmake pkgconfig git python3 python3Packages.lxml
                  glslang spirv-tools x11 libxcb wayland jq
                ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_WSI_WAYLAND_SUPPORT=ON" # XLIB/XCB supported by default
  ];

  installPhase = ''
    mkdir -p "$out/lib"
    cp layers/lib* "$out/lib"
    cp loader/libvulkan.so* "$out/lib"

    mkdir -p $out/share/vulkan/explicit_layer.d
    for FILE in layers/*.json; do # */
      jq ".layer.library_path = \"$out/\" + .layer.library_path[2:]" < $FILE > tmp.json
      mv tmp.json $FILE
    done
    cp layers/*.json "$out/share/vulkan/explicit_layer.d" #*/

    mkdir -p "$out/bin"
    cp demos/vulkaninfo "$out/bin"

    cp -r ../include "$out/include"
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = http://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = with maintainers; [ ralith ];
  };
}
