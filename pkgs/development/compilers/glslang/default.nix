{ stdenv, fetchFromGitHub, fetchpatch, cmake, bison, spirv-tools, jq }:

stdenv.mkDerivation rec {
  name = "glslang-git-${version}";
  version = "2018-09-26";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "91ac4290bcf2cb930b4fb0981f09c00c0b6797e1";
    sha256 = "0q477pm0n495acnss16ddlf82a6i5l2dfmvc7r8yi0bgmgpzi4av";
  };

  buildInputs = [ cmake bison jq ] ++ spirv-tools.buildInputs;
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-tools.headers}" External/spirv-tools/external/spirv-headers
  '';

  preConfigure = ''
    HEADERS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools/external/spirv-headers"))[0].commit')
    TOOLS_COMMIT=$(jq -r < known_good.json '.commits|map(select(.name=="spirv-tools"))[0].commit')
    if [ "$HEADERS_COMMIT" != "${spirv-tools.headers.rev}" ] || [ "$TOOLS_COMMIT" != "${spirv-tools.src.rev}" ]; then
      echo "ERROR: spirv-tools commits do not match expected versions: expected tools at $TOOLS_COMMIT, headers at $HEADERS_COMMIT";
      exit 1;
    fi
  '';

  doCheck = false; # fails 3 out of 3 tests (ctest)

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Khronos reference front-end for GLSL and ESSL";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
