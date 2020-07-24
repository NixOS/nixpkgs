{ stdenv, fetchFromGitHub
, bison
, cmake
, jq
, python3
, spirv-headers
, spirv-tools
}:

stdenv.mkDerivation rec {
  pname = "glslang";
  version = "8.13.3559";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = version;
    sha256 = "0waamlh2vqh1k40m169294xdlm0iqjkx2vis4qyxfki0r0cnsmnk";
  };

  # These get set at all-packages, keep onto them for child drvs
  passthru = {
    inherit spirv-tools spirv-headers;
  };

  nativeBuildInputs = [ cmake python3 bison jq ];
  enableParallelBuilding = true;

  postPatch = ''
    cp --no-preserve=mode -r "${spirv-tools.src}" External/spirv-tools
    ln -s "${spirv-headers.src}" External/spirv-tools/external/spirv-headers
  '';

  # Ensure spirv-headers and spirv-tools match exactly to what is expected
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
