{ stdenv, fetchFromGitHub, cmake, bison, spirv-tools, jq }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2018-02-05";

  # `vulkan-loader` requires a specific version of `glslang` as specified in
  # `<vulkan-loader-repo>/external_revisions/glslang_revision`.
  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "2651ccaec8";
    sha256 = "0x5x5i07n9g809rzf5jgw70mmwck31ishdmxnmi0wxx737jjqwaq";
  };

  buildInputs = [ cmake bison jq ] ++ spirv-tools.buildInputs;
  enableParallelBuilding = true;

  patchPhase = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-tools.headers}" External/spirv-tools/external/spirv-headers
  '';

  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${spirv-tools.headers.rev}" ] || [ "$TOOLS_COMMIT" != "${spirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions";
      exit 1;
    fi
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
