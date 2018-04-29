{ stdenv, fetchgit, fetchFromGitHub, cmake, pkgconfig, git, python3,
  python3Packages, glslang, spirv-tools, x11, libxcb, libXrandr,
  libXext, wayland, libGL_driver, makeWrapper }:

let
  version = "1.1.70.0";
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-LoaderAndValidationLayers";
    rev = "sdk-${version}";
    sha256 = "1a7xwl65bi03l4zbjq54qkxjb8kb4m78qvw8bas5alhf9v6i6yqp";
  };
in

stdenv.mkDerivation rec {
  name = "vulkan-loader-${version}";
  inherit version src;

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [ cmake git python3 python3Packages.lxml
                  glslang x11 libxcb libXrandr libXext wayland
                ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_WSI_MIR_SUPPORT=OFF"
    "-DFALLBACK_DATA_DIRS=${libGL_driver.driverLink}/share:/usr/local/share:/usr/share"
  ];

  outputs = [ "out" "dev" "demos" ];
  patches = [ ./rev-file.patch ];

  postUnpack = ''
    # Hack so a version header can be generated. Relies on ./rev-file.patch to work.
    mkdir -p "$sourceRoot/external/glslang/External"
    echo "${spirv-tools.src.rev}" > "$sourceRoot/external/glslang/External/spirv-tools"
  '';

  preConfigure = ''
    checkRev() {
      [ "$2" = $(cat "external_revisions/$1_revision") ] || (echo "ERROR: dependency $1 is revision $2 but should be revision" $(cat "external_revisions/$1_revision") && exit 1)
    }
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
    mkdir -p $demos/share/vulkan-demos
    cp demos/*.spv demos/*.ppm $demos/share/vulkan-demos
    mkdir -p $demos/bin
    find demos -type f -executable -not -name vulkaninfo -exec cp -v {} $demos/bin \;
    for p in cube cubepp; do
      wrapProgram $demos/bin/$p --run "cd $demos/share/vulkan-demos"
    done
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = "http://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
