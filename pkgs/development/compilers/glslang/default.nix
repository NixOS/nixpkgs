{ stdenv, fetchFromGitHub, cmake, bison, jq, python, spirv-tools, spirv-headers }:
stdenv.mkDerivation rec {
  name = "glslang-${version}";
  version = "7.11.3113";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "${version}";
    sha256 = "1kzv2b4q1fddxd7c0hc754nd6rw6y9vijb9fsi13xzzq9dficgb6";
  };

  nativeBuildInputs = [ cmake python bison jq ];
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${spirv-headers.src.rev}" ] || [ "$TOOLS_COMMIT" != "${spirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions: expected tools at $TOOLS_COMMIT, headers at $HEADERS_COMMIT";
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
